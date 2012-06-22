class UserNotification < ActiveRecord::Base

  belongs_to :user
  belongs_to :feed_item

  validate :user_id, :feed_item_id, :numericality => { :only_integer => true }
  validates :creation_date, :presence => true

  def self.process_notifications(feed_item)
    feed_item.user.increment_new_notifications_count
    EmailNotification.process_email_notification feed_item
    ApnNotification.deliver feed_item
  end

  def format_message
    message_template = "notification.#{self.feed_item.action}"

    case self.feed_item.action
    when "comment_video", "like_video"
      I18n.t message_template, :user => self.user.username, :event => self.feed_item.context.name
    when "follow", "mention"
      I18n.t message_template, :user => self.user.username
    when "add_song"
      I18n.t message_template
    end
  end

  protected

  def self.create_by_feed_item(feed_item)
    self.new(:user_id => feed_item.user_id, :feed_item_id => feed_item.id, :creation_date => Time.now)
  end

end