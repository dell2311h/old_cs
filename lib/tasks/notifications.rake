namespace :cs do
  desc "Notifications"
  namespace :notifications do
    desc "Deliver notifications for period"
    task :deliver => :environment do
      UserNotification.send_email_notifications
    end
  end
end