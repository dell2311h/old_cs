class UserNotification < ActiveRecord::Base

  belongs_to :user
  belongs_to :feed_item

  validate :user_id, :feed_item_id, :numericality => { :only_integer => true }
  validates :creation_date, :presence => true

  def deliver_email_notification
    text = format_notification_text
    email = self.user.email
    NotificationMailer.send_single_notification(email, text).deliver
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

  private

  def self.creat_by(feed_item)
    UserNotification.new(:user_id => feed_item.user_id, :feed_item_id => feed_item.id, :creation_date => Time.now)
  end

  def format_notification_text
    message_template = "notification.email.self.#{self.feed_item.action}"

    case self.feed_item.action
    when "comment_video", "like_video"
      I18n.t message_template
    when "follow", "mention"
      I18n.t message_template, :user => self.feed_item.user_id
    when "add_song"
      I18n.t message_template
    end
  end

end