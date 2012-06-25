class AddNewNotificationsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :new_notifications_count, :integer, :default => 0
  end
end
