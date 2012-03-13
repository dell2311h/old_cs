class CreateVideoSongs < ActiveRecord::Migration
  def change
    create_table :video_songs do |t|
      t.integer :user_id
      t.integer :song_id
      t.integer :video_id

      t.timestamps
    end
  end
end
