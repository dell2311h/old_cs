class Song < ActiveRecord::Base
  has_many :video_songs, dependent: :destroy
  has_many :videos, through: :video_songs

  validates :name, presence: true, uniqueness: true

  scope :suggestions_by_name, lambda {|name| where("UPPER(name) LIKE ?", "#{name.to_s.upcase}%") }

  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

  scope :with_videos_count, select("songs.*").select("(#{VideoSong.select("COUNT(video_songs.song_id)").where("songs.id = video_songs.song_id").to_sql}) AS videos_count")

  scope :with_comments_count, select("songs.*").select("SUM((#{Comment.select("COUNT(comments.commentable_id)").where("videos.id = comments.commentable_id AND comments.commentable_type = 'Video'").to_sql})) as comments_count").joins(:videos).group("songs.id")

  scope :with_calculated_counters, with_videos_count.with_comments_count

  self.per_page = Settings.paggination.per_page

  def most_popular_video
    self.videos.most_popular.first
  end

  def comments_count
    comments_amount = 0
    self.videos.each do |video|
      comments_amount += video.comments.count
    end
    comments_amount
  end
end

