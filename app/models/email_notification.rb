class EmailNotification < UserNotification

  def self.process_email_notification(feed_item)
    case feed_item.user.email_notification_status
    when "day", "week"
      notification = create_by_feed_item(feed_item)
      notification.save
    when "immediate"
      notification = create_by_feed_item(feed_item)
      notification.deliver
    end

  end

  def self.deliver_undelivered
    notifications = find_undelivered.group_by(& :user_id)

    notifications.each {|user_id, user_notifications| self.deliver_multiply user_notifications}
  end

  def deliver
    text = format_message
    email = self.user.email
    NotificationMailer.send_single_notification(email, text).deliver
  end

  private

  def self.deliver_multiply(notifications)
    texts = []
    notifications.each { |notification| texts << notification.format_message }
    email = notifications.first.user.email
    period = Time.now - notifications.first.user.read_attribute(:email_notification_status).days
    begin
      NotificationMailer.send_multiply_notifications(email, texts, period).deliver
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

