namespace :cs do
  desc "Notifications"
  namespace :notifications do
    desc "Deliver notifications for period"
    task :deliver => :environment do
      EmailNotification.deliver_undelivered
    end
  end
end