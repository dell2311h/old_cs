namespace :cs do
  desc "Notifications"
  namespace :notifications do
    desc "Deliver email notifications"
    task :deliver_email => :environment do
      UserNotification.deliver_undelivered
    end

    desc "Deliver apn notifications"
    task :deliver_apn => :environment do
      ApnNotification.deliver_undelivered
    end
  end
end