class AddEmailNotificationSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_notification_status, :string, :default => 'none'
  end
end
