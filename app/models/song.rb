class Song < ActiveRecord::Base
  has_many :video_songs, dependent: :destroy
  has_many :videos, through: :video_songs
  
  validates :name, presence: true, uniqueness: true
  
  scope :suggestions_by_name, lambda {|name| where("UPPER(name) LIKE ?", "#{name.to_s.upcase}%") }
  
  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }
  
end
