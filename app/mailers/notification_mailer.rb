class NotificationMailer < ActionMailer::Base
  default from: Settings.mailers.email.noreply

  def send_single_notification(receiver, notification)
    @notification = notification
    mail(:to => receiver, :subject => "#{Settings.application.name} notification")
  end

  def send_multiply_notifications(receiver, notifications)
    @notifications = notifications
    mail(:to => receiver, :subject => "#{Settings.application.name} notifications")
  end

end
