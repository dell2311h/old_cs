class ChangeUserLoginToUsername < ActiveRecord::Migration
  def up
    rename_column :users, :login, :username
  end

  def down
    rename_column :table, :username, :login
  end
end
