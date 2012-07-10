class RemoveDeviceFromUsersTable < ActiveRecord::Migration
  def up
    remove_column :users, :device_token
  end

  def down
    add_column :users, :device_token, :string
  end
end
