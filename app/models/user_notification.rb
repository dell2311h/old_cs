class UserNotification < ActiveRecord::Base

  belongs_to :user
  belongs_to :feed_item

  validate :user_id, :feed_item_id, :numericality => { :only_integer => true }
  validates :creation_date, :presence => true

  def self.process_notifications(feed_item)
    feed_item.user.increment_new_notifications_count
    message = self.format_message feed_item
    UserNotification.process_email_notification message, feed_item
    ApnNotification.store message, feed_item.user
  end

  def self.format_message feed_item
    message_template = "notification.#{feed_item.action}"

    case feed_item.action
    when "comment_video", "like_video"
      I18n.t message_template, :user => feed_item.user.username, :event => feed_item.context.name
    when "follow", "mention"
      I18n.t message_template, :user => feed_item.user.username
    when "add_song"
      I18n.t message_template
    end
  end

  def self.deliver_undelivered
    notifications = find_undelivered.group_by(& :user_id)

    notifications.each {|user_id, user_notifications| self.deliver_multiply user_notifications}
  end

  protected

  def self.create_by_feed_item(feed_item)
    self.new(:user_id => feed_item.user_id, :feed_item_id => feed_item.id, :creation_date => Time.now)
  end

  def self.process_email_notification(message, feed_item)
    case feed_item.user.email_notification_status
    when "day", "week"
      notification = create_by_feed_item(feed_item)
      notification.save
    when "immediate"
      notification = create_by_feed_item(feed_item)
      notification.deliver
    end
  end

  def deliver
    text = self.format_message self.feed_item
    email = self.user.email
    NotificationMailer.send_single_notification(email, text).deliver
  end

  def self.format_multiply_notifications(notifications)
    texts = []
    notifications.each { |notification| texts << self.format_message(notification.feed_item) }
    email = notifications.first.user.email
    period = Time.now - notifications.first.user.read_attribute(:email_notification_status).days

    {:email => email, :period => period, :texts => texts}
  end

  def self.deliver_multiply(notifications)
    notification_params = self.format_multiply_notifications notifications

    begin
      NotificationMailer.send_multiply_notifications(notification_params[:email],
                                                     notification_params[:texts],
                                                     notification_params[:period]).deliver
      self.destroy_delivered(notifications)
    rescue
    end
  end

  def self.destroy_delivered(notifications)
    notifications.each { |notification| notification.destroy}
  end

  def self.find_undelivered
    user_notifications = UserNotification.where("(users.email_notification_status IS NOT NULL)  AND (DATEDIFF(?, creation_date) >= users.email_notification_status)", Time.now)
    user_notifications.joins(:user).includes(:user, :feed_item)
  end



end