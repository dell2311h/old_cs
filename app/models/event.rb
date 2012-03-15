class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  has_many :videos
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy
   
  has_many :taggings, as: :taggable, class_name: "Tagging", dependent: :destroy
  has_many :tags, through: :taggings

  has_attached_file :image, :styles => { :iphone => "200x200>" }
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/pjpeg', 'image/png', 'image/gif']

  validates :name, :presence => true
  validates :user_id, :place_id, :presence => true

  scope :order_by_video_count, lambda {
    videos = Video.arel_table
    events = Event.arel_table
    query_str = videos.project(videos[:event_id].count).where(events[:id].eq(videos[:event_id])).to_sql
    select("*, (#{query_str}) AS videos_count").order('videos_count DESC')
  }

  # coordinates = [latitude, longitude]
  scope :nearby, lambda { |coordinates, radius|
    Event.joins(:place).merge(Place.near coordinates, radius, :order => :distance, :select => "places.*, places.name AS place_name, events.*")
  }
  
  def songs
    Song.find_by_sql(["SELECT DISTINCT (songs.id), songs.name FROM songs INNER JOIN video_songs ON video_songs.song_id = songs.id INNER JOIN videos ON videos.id = video_songs.video_id WHERE videos.event_id = ?", self.id])
  end
    
  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

end

