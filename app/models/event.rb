class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  has_many :videos
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy
  has_many :taggings, as: :taggable, class_name: "Tagging", dependent: :destroy
  has_many :tags, through: :taggings
  has_and_belongs_to_many :performers

  validates :name, :date, presence: true
  validates :user_id, :place_id, presence: true

  before_create :add_eventful_event

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

  scope :with_videos_comments_count, select("events.*").select("SUM((#{Comment.select("COUNT(comments.commentable_id)").where("videos.id = comments.commentable_id AND comments.commentable_type = 'Video'").to_sql})) as comments_count").joins(:videos).group("events.id")

  def videos_comments
    videos.joins(:comments).select("comments.*")
  end

  def most_popular_video
    self.videos.most_popular.first
  end

  self.per_page = Settings.paggination.per_page

  def songs
    Song.select("DISTINCT (songs.id), songs.name").joins(:videos).where("videos.event_id = ?", self.id)
  end

  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

  scope :around_date, lambda { |search_date| where(:date => (search_date - 1.day)..(search_date)) }

  def playlist
    videos = Video.find_videos_for_playlist self.id

    playlist = Playlist.new
    playlist.format videos

    playlist.timelines
  end

  private

    def add_eventful_event
      unless self.eventful_id.nil?
        found_event = Event.get_eventful_event self.eventful_id
          if found_event.nil?
            eventful_id = Event.create_eventful_event self
            self.eventful_id = eventful_id
          end
      else
        self.eventful_id = Event.create_eventful_event self
      end
    end

    def self.get_eventful_event id
      event = EventfulEvent.get_event :id => id

      event
    end

    def self.create_eventful_event event
      params = {:title => event.name, :start_time => event.date}
      params[:venur_id] = event.place.eventful_id unless event.place.eventful_id.nil?
      output = EventfulEvent.create_event params

      return output.id unless output[:id].nil?

      nil
    end

end

