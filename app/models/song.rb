class Song < ActiveRecord::Base
  has_many :video_songs, dependent: :destroy
  has_many :videos, through: :video_songs
  
  validates :name, presence: true
end
