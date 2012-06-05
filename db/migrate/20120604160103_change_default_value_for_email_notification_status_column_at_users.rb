class ChangeDefaultValueForEmailNotificationStatusColumnAtUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :email_notification_status, "week"
  end
end

