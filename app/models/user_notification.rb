class UserNotification < ActiveRecord::Base

  belongs_to :user
  belongs_to :feed_item

  validate :user_id, :feed_item_id, :numericality => { :only_integer => true }
  validates :creation_date, :presence => true

  def deliver_email_notification
    text = format_notification_text
    email = self.user.email
    NotificationMailer.send_single_notification(email, text).deliver
    self.destroy
  end

  def self.process_email_notification(feed_item)

    case feed_item.user.email_notification_status
    when "day", "week"
      notification = creat_by(feed_item)
      notification.save
    when "immediate"
      notification = creat_by(feed_item)
      deliver_email_notification
    end

  end

  def self.send_email_notifications
    notifications = find_notification_to_deliver().group_by(& :user_id)

    notifications.each {|user_id, user_notification| self.deliver_email_notifications user_notification}
  end

  def format_notification_text
    message_template = "notification.email.#{self.feed_item.action}"

    case self.feed_item.action
    when "comment_video", "like_video"
      I18n.t message_template
    when "follow", "mention"
      I18n.t message_template, :user => self.user.username
    when "add_song"
      I18n.t message_template
    end
  end

  private

  def self.deliver_email_notifications(notifications)
    texts = []
    notifications.each { |notification| texts << notification.format_notification_text }
    email = notifications.first.user.email
    period = Time.now - notifications.first.user.read_attribute(:email_notification_status).days
    begin
      NotificationMailer.send_multiply_notifications(email, texts, period).deliver
      notifications.each { |notification| notification.destroy}
    rescue
    end
  end

  def self.find_notification_to_deliver
    user_notifications = UserNotification.where("(users.email_notification_status > 0)  AND (DATEDIFF(?, creation_date) >= users.email_notification_status)", Time.now)
    user_notifications.joins(:user).includes(:user, :feed_item)
  end

  def self.creat_by(feed_item)
    UserNotification.new(:user_id => feed_item.user_id, :feed_item_id => feed_item.id, :creation_date => Time.now)
  end

end