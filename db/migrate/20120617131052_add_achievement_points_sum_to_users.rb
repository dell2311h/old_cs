class AddAchievementPointsSumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :achievement_points_sum, :integer, {:default => 0}

  end
end
