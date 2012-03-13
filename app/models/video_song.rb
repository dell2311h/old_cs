class VideoSong < ActiveRecord::Base
  belongs_to :user
  belongs_to :song
  belongs_to :video
  
  validates :song_id, :video_id, presence: true
end
