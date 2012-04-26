class Song < ActiveRecord::Base
  has_many :video_songs, dependent: :destroy
  has_many :videos, through: :video_songs

  validates :name, presence: true, uniqueness: true

  scope :suggestions_by_name, lambda {|name| where("UPPER(name) LIKE ?", "#{name.to_s.upcase}%") }

  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

  scope :with_videos_count, select("songs.*").select("(#{VideoSong.select("COUNT(video_songs.song_id)").where("songs.id = video_songs.song_id").to_sql}) AS videos_count")

  scope :with_comments_count, select("songs.*").select("SUM((#{Comment.select("COUNT(comments.commentable_id)").where("videos.id = comments.commentable_id AND comments.commentable_type = 'Video'").to_sql})) as comments_count").joins(:videos).group("songs.id")

  scope :with_calculated_counters, with_videos_count.with_comments_count

  scope :search, lambda { |params|

    # ATTENTION:
    #  scope chaining will be overrided if any of that keys:
    #  :video_id, :event_id, :song_name or :q are presented at params

    songs = scoped
    songs = Video.find(params[:video_id]).songs if params[:video_id]
    songs = Event.find(params[:event_id]).songs if params[:event_id]
    songs = Song.suggestions_by_name(params[:song_name]) if params[:song_name]
    songs = Song.with_name_like(params[:q]) if params[:q]

    songs.scoped
  }

  self.per_page = Settings.paggination.per_page

  def most_popular_video
    self.videos.most_popular.first
  end

end

