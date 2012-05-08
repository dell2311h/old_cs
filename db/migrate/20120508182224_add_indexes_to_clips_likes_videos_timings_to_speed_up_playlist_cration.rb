class AddIndexesToClipsLikesVideosTimingsToSpeedUpPlaylistCration < ActiveRecord::Migration
  def change
    add_index :clips,   :video_id
    add_index :likes,   :video_id
    add_index :timings, :video_id
    add_index :videos,  :event_id
  end
end
