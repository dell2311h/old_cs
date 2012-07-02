class Event < ActiveRecord::Base

  include Follow::Relations
  include Follow::FlagsAndCounters

  belongs_to :user
  belongs_to :place
  has_many :videos, dependent: :destroy

  has_many :master_tracks, dependent: :destroy

  validates :name, :date, presence: true
  validates :user_id, :place_id, presence: true

  after_create :create_pluraleyes_project

  scope :order_by_video_count, lambda {
    select("*, (#{Video.select("COUNT(videos.event_id)")
                       .where("videos.status = #{Video::STATUS_PROCESSING_DONE} AND events.id = videos.event_id").to_sql}) AS videos_count").order('videos_count DESC')
  }

  # coordinates = [latitude, longitude]
  scope :nearby, lambda { |coordinates, radius|
    Event.joins(:place).merge(Place.near coordinates, radius, :order => :distance, :select => "places.*, places.name AS place_name, events.*")
  }

  scope :with_videos_comments_count, select("events.*").select("SUM((#{Comment.select("COUNT(comments.video_id)").where("videos.id = comments.video_id ").to_sql})) as comments_count").joins("LEFT OUTER JOIN `videos` ON `videos`.`event_id` = `events`.`id`").group("events.id")

  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

  scope :around_date, lambda { |search_date| where(:date => (search_date - 1.day)..(search_date)) }

  scope :with_calculated_counters, with_followers_count.with_videos_comments_count

  def self.top_random_for count
    events = Event.order_by_video_count.limit count

    events.sample
  end

  def current_master_track
    master_tracks.where("version = ? AND is_ready = ?", master_track_version, true).first
  end

  def videos_comments
    videos.joins(:comments).select("comments.*").order("comments.created_at DESC")
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
    Video.unscoped.where(:event_id => self.id).joins(:clips)
                  .where("clips.clip_type = ?", Clip::TYPE_DEMUX_AUDIO)
                  .where("clips.synced = ?", false)
                  .count >= 1
  end

  def sync_with_pluraleyes
    require 'pe_hydra'
    hydra = PeHydra::Query.new(Settings.pluraleyes.login, Settings.pluraleyes.password)
    hydra.sync(self.pluraleyes_id)
  end

  def send_master_track_creation_to_encoding_with(data)
    profile = EncodingProfile.find_by_name "master_track"
    params = { :profile_id => profile.profile_id,
               :encoder => { :input_media_ids => data[:media_ids],
                             :params => { :cutting_timings => data[:cutting_timings],
                                          :destination => "encoded/#{self.id}/master_tracks/#{data[:master_track].id}/audio.mp3"
                              }
                            }
              }
    response = Pandrino::Api.deliver Settings.encoding.url.actions.encoders, params
    raise 'Unable to send clips to master_track creation' unless response["status"] == 'ok'
    raise 'encoder_id is not provided at response' unless response["encoder_id"]
    data[:master_track].update_attribute :encoder_id, response["encoder_id"]
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
      timestamp = Video.unscoped.where(:id => clip.video_id).first.meta_info.recorded_at.to_i
      last_synched_clip = sorted_group.last
      group_duration = last_synched_clip[:end].to_i
      groups_with_timestamp_and_duration << { pe_group: sorted_group, starts_at: timestamp, duration: group_duration }
    end

    # Sort groups by their chronological order
    groups_with_timestamp_and_duration.sort! { |x, y| x[:starts_at] <=> y[:starts_at] }

    # create timings by prepared PluralEyes results
    group_time_offset = 0 # miliseconds

    clips_to_cut = [] # Encoding media ids
    timings_to_cut = [] # Timings for this medias to cut them

    groups_with_timestamp_and_duration.each do |group|
      # group { :pe_group => [...], :starts_at => timestamp, :duration => miliseconds }
      pluraleyes_group = group[:pe_group]

      previous_clip = nil # Previous synced_clip inside group

      pluraleyes_group.each do |synced_clip|
        clip = Clip.find_by_pluraleyes_id synced_clip[:media_id]
        clip.update_attribute(:synced, true) # mark audio as allready included in mastertrack

        # Create timings for videos
        timing = Timing.create! :video_id => clip.video_id, :start_time => synced_clip[:start].to_i + group_time_offset, :end_time => synced_clip[:end].to_i + group_time_offset, :version => new_master_track.version

        # Prepare timings for Encoding master track creation
        if !previous_clip or (previous_clip and (previous_clip[:end].to_i < synced_clip[:end].to_i))
          cut_start = previous_clip ? (previous_clip[:end].to_i - synced_clip[:start].to_i) : 0
          clip_duration = synced_clip[:end].to_i - synced_clip[:start].to_i
          timings_to_cut << { start_time: cut_start, end_time: clip_duration }
          clips_to_cut << clip.encoding_id
          previous_clip = synced_clip
        end
      end
      group_time_offset += group[:duration]
    end

    { media_ids: clips_to_cut, cutting_timings: timings_to_cut, master_track: new_master_track } # Prepared data for cutting medias at Encoding
  end

  def make_new_master_track
    sync_results = self.sync_with_pluraleyes # Sync with PluralEyes
    result = self.create_timings_by_pluraleyes_sync_results(sync_results) # Create timings
    self.send_master_track_creation_to_encoding_with(result) # Enqueue master track creation at Encoding Server
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
