class ModifyUsersTable < ActiveRecord::Migration
  def change

    add_column :users, :sex, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :points, :integer, :default => 0

    remove_column :users, :name
  end
end

