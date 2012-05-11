class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  has_many :videos
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy
  has_many :taggings, as: :taggable, class_name: "Tagging", dependent: :destroy
  has_many :tags, through: :taggings
  has_and_belongs_to_many :performers
  has_many :master_tracks, dependent: :destroy

  validates :name, :date, presence: true
  validates :user_id, :place_id, presence: true

  before_create :add_eventful_event

  after_create :create_pluraleyes_project

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

  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

  scope :around_date, lambda { |search_date| where(:date => (search_date - 1.day)..(search_date)) }


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

  def playlist
    videos = Video.find_videos_for_playlist self.id

    playlist = Playlist.new
    playlist.format videos

    playlist.timelines
  end

  # Create mastetrack placeholder
  def create_not_ready_master_track
    last_master_track = self.master_tracks.first
    self.master_tracks.create :version => (last_master_track ? (last_master_track.version + 1) : 0)
  end

  def sync_with_pluraleyes?
    self.videos.joins(:clips).where("clips.clip_type = ?", Clip::TYPE_DEMUX_AUDIO).count >= Settings.sync_with_pluraleyes.minimal_amount_of_videos
  end

  def sync_with_pluraleyes
    require 'pe_hydra'
    hydra = PeHydra::Query.new Settings.pluraleyes.login, Settings.pluraleyes.password
    sync_results = hydra.sync self.pluraleyes_id
    self.create_timings_by_pluraleyes_sync_results sync_results
  end

  # Timings creation
  def create_timings_by_pluraleyes_sync_results pe_sync_results = []

    # Prepare new master track
    new_master_track = self.create_not_ready_master_track

    # prepare PluralEyes results for timings creation
    groups_with_timestamp_and_duration = []
    pe_sync_results.each do |group|
      sorted_group = group.sort { |x, y| x[:start].to_i <=> y[:start].to_i }
      first_synched_clip = sorted_group[0]
      clip = Clip.find_by_pluraleyes_id first_synched_clip[:media_id]
      timestamp = clip.video.meta_info.recorded_at.to_i
      last_synched_clip = sorted_group.last
      group_duration = last_synched_clip[:end].to_i
      groups_with_timestamp_and_duration << { pe_group: sorted_group, starts_at: timestamp, duration: group_duration }
    end

    # Sort groups by their chronological order
    groups_with_timestamp_and_duration.sort! { |x, y| x[:starts_at] <=> y[:starts_at] }

    # create timings by prepared PluralEyes results
    group_time_offset = 0 # miliseconds
    groups_with_timestamp_and_duration.each do |group|
      # group { :pe_group => [...], :starts_at => timestamp, :duration => miliseconds }
      pluraleyes_group = group[:pe_group]
      pluraleyes_group.each do |synced_clip|
        clip = Clip.find_by_pluraleyes_id synced_clip[:media_id]
        timing = clip.video.timings.create! :start_time => synced_clip[:start].to_i + group_time_offset, :end_time => synced_clip[:end].to_i + group_time_offset, :version => new_master_track.version
      end
      group_time_offset += group[:duration]
    end
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

    def create_pluraleyes_project
      require 'pe_hydra'
      hydra = PeHydra::Query.new Settings.pluraleyes.login, Settings.pluraleyes.password
      pe_project = hydra.create_project self.name
      self.update_attribute :pluraleyes_id, pe_project[:id]
      Rails.logger.info "PluralEyes project created. Project ID #{self.pluraleyes_id}"
    end

end

