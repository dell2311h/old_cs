class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  has_many :videos
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy
  
  
  has_many :taggings, as: :taggable, class_name: "Tagging", dependent: :destroy
  has_many :tags, through: :taggings


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

end

