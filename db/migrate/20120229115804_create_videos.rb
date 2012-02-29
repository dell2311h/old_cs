class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :name

      t.timestamps
    end
  end
end
