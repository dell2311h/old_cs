class RemovePointsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :points
      end

  def down
    add_column :users, :points, :integer
  end
end
