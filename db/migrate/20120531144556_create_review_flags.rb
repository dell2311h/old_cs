class CreateReviewFlags < ActiveRecord::Migration
  def change
    create_table :review_flags do |t|
      t.integer :user_id
      t.integer :video_id

      t.timestamps
    end
  end
end
