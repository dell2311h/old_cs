class CreateAchievementPoints < ActiveRecord::Migration
  def change
    create_table :achievement_points do |t|
      t.integer :user_id
      t.integer :points
      t.integer :reason_code

      t.timestamps
    end
  end
end
