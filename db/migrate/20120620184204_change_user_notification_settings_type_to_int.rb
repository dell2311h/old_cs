class ChangeUserNotificationSettingsTypeToInt < ActiveRecord::Migration
  def up
    change_column :users, :email_notification_status, :integer, default: 7
  end

  def down
    change_column :users, :email_notification_status, :string, default: 'week'
  end
end
