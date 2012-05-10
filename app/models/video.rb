class Video < ActiveRecord::Base

  STATUS_UPLOADING = -1
  STATUS_NEW = 0
  STATUS_DEMUX_WORKING = 1
  STATUS_DEMUX_DONE = 2
  STATUS_STREAMING_WORKING = 3
  STATUS_STREAMING_DONE = 4

  attr_accessible :clip, :event_id, :user_id, :uuid, :tags, :songs, :thumbnail

  mount_uploader :thumbnail, ThumbnailUploader
#  validates_presence_of :thumbnail

  mount_uploader :clip, ClipUploader

  validates :user_id , :event_id, :uuid, :presence => true
  validates :user_id, :event_id, :numericality => { :only_integer => true }

  belongs_to :event
  belongs_to :user
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy

  has_many :taggings, as: :taggable, class_name: "Tagging", dependent: :destroy
  has_many :tags, through: :taggings

  has_many :video_songs, dependent: :destroy
  has_many :songs, through: :video_songs

  has_many :clips, dependent: :destroy
  has_one  :demux_video, :class_name => 'Clip', :conditions => { :clip_type => Clip::TYPE_DEMUX_VIDEO }
  has_one  :demux_audio, :class_name => 'Clip', :conditions => { :clip_type => Clip::TYPE_DEMUX_AUDIO }
  has_one  :streaming,   :class_name => 'Clip', :conditions => { :clip_type => Clip::TYPE_STREAMING }

  has_many :likes
  has_many :likers, :through => :likes, :source => :user

  has_many :timings, dependent: :destroy

  # default scope to hide videos that are not ready.
  default_scope where(:status => STATUS_STREAMING_DONE)

  scope :for_user, lambda { |user| where(:user_id => user.id) }
  scope :likes_count, lambda { select("videos.*, COUNT(likes.id) AS likes_count").
                               joins("LEFT OUTER JOIN `likes` ON `likes`.`video_id` = `videos`.`id`").
                               group "videos.id"
                              }
  scope :most_popular, lambda {
    select("videos.*").select("(#{Like.select("COUNT(likes.video_id)").where("videos.id = likes.video_id").to_sql}) AS likes_count").order('likes_count DESC')
  }

  scope :search, lambda {|params| videos = scoped
                          videos = videos.where("videos.user_id = ?", params[:user_id]) if params[:user_id]
                          videos = videos.where("videos.event_id = ?", params[:event_id]) if params[:event_id]
                          videos = videos.joins(:songs).where("songs.id = ?", params[:song_id]) if params[:song_id]
                          videos
                        }

  scope :with_flag_liked_by_me, lambda { |user| select('videos.*').select("(#{Like.select('COUNT(user_id)').where('likes.video_id = videos.id AND likes.user_id = ?', user.id).to_sql}) AS liked_by_me") }

  scope :with_likes_count, select('videos.*').select("(#{Like.select("COUNT(likes.video_id)").where("videos.id = likes.video_id").to_sql}) AS likes_count")

  scope :with_comments_count, select('videos.*').select("(#{Comment.select("COUNT(comments.commentable_id)").where("videos.id = comments.commentable_id AND comments.commentable_type = 'Video'").to_sql}) AS comments_count")

  scope :with_calculated_counters, with_likes_count.with_comments_count

  scope :with_events_and_users, lambda{
                                        @@users = User.find scoped.map(&:user_id).uniq
                                        @@events = Event.find scoped.map(&:event_id).uniq
                                        scoped
                                      }

  self.per_page = Settings.paggination.per_page

  def self.find_videos_for_playlist event_id
    videos = Video.select "videos.id, timings.start_time as start_time, timings.end_time as end_time, clips.source as source, (SELECT count(*) from likes where videos.id = likes.video_id) as rating"
    videos = videos.joins 'LEFT JOIN clips on clips.clip_type = "demux_video" AND clips.video_id = videos.id'
    videos = videos.joins 'LEFT JOIN events on events.id = videos.event_id'
    videos = videos.joins 'LEFT JOIN timings on videos.id = timings.video_id AND timings.version = events.master_track_version'
    videos = videos.where "videos.event_id = ?", event_id
    videos = videos.group "rating desc, start_time, end_time"

    videos
  end

  def cached_user
    @@users ? @@users.select { |user| user.id == self.user_id }.first : self.user
  end

  def cached_event
    @@events ? @@events.select { |event| event.id == self.event_id }.first : self.event
  end

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => self.name,
      "size" => self.clip.file.size,
      "url" => self.clip.url,
      "thumbnail_url" => "",
      "delete_url" => "/videos/#{self.id}",
      "delete_type" => "DELETE"
    }
  end

  def self.find_by_clip_encoding_id encoding_id
    Video.joins(:clips).where('clips.encoding_id' => encoding_id).first
  end

  # Overriding "tags=" method for adding tags by their name
  def tags=(tags_names)
    tags_names.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name.downcase)
      self.tags << tag if !self.tags.find_by_id(tag)
    end
    self.tags.map(&:name)
  end

  def add_songs_by songs_params
    songs_params.each do |song_params|
      song = song_params[:id] ? Song.find(song_params[:id]) : Song.create!(song_params)
      self.songs << song if !self.songs.find_by_id(song)
    end
    self.songs
  end

  def self.unscoped_find video_id
    Video.unscoped.find video_id
  end

  #----- Chunked uploading ---------------

  after_create do |video|
    # Prepare upload folder
    video.make_uploads_folder!
  end

  after_destroy do |video|
    # Remove uploaded data
    video.remove_attached_data!
  end

  TMPFILES_DIR = "#{::Rails.root}/tmp/uploads"
  UPLOADS_FOLDER = TMPFILES_DIR + "/videos"

  def directory_fullpath
    UPLOADS_FOLDER + "/#{self.id}"
  end

  def tmpfile_fullpath
    "#{directory_fullpath}/tmpfile"
  end

  def make_uploads_folder!
    Dir.mkdir(TMPFILES_DIR) unless File.directory? TMPFILES_DIR # create dir if it is not exist
    Dir.mkdir(UPLOADS_FOLDER) unless File.directory? UPLOADS_FOLDER # create dir if it is not exist
    Dir.mkdir(self.directory_fullpath) unless File.directory? self.directory_fullpath # create dir if it is not exist
  end

  def remove_attached_data!
    FileUtils.rm_rf self.directory_fullpath
  end

  # Wrapper for http data
  def append_chunk_to_file! chunk_params
    raise "Empty chunk" unless chunk_params
    raise "Chunk id is empty" unless chunk_params[:id]
    raise "Chunk data is invalid" unless chunk_params[:data].respond_to?(:tempfile)
    self.append_binary_to_file! chunk_params[:id].to_i, chunk_params[:data].tempfile.read
  end

  def append_binary_to_file! chunk_id, chunk_binary
    raise "Can't add data to finalized upload" unless self.status == STATUS_UPLOADING
    set_chunk_id! chunk_id
    File.open(self.tmpfile_fullpath, 'ab') { |file| file.write(chunk_binary) }
  end

  def tmpfile_md5_checksum
    Digest::MD5.hexdigest(File.read(self.tmpfile_fullpath)) if File.file? self.tmpfile_fullpath
  end

  def tmpfile_size
    File.size self.tmpfile_fullpath if File.file? self.tmpfile_fullpath
  end

  def renamed_file_fullpath_by filename
    "#{directory_fullpath}/#{filename}"
  end

  def finalize_upload_by! file_params
    raise "Empty file params" unless file_params
    raise "File name is empty" unless file_params[:name]
    raise "File checksum is empty" unless file_params[:checksum]
    filename = file_params[:name]
    uploaded_file_checksum = file_params[:checksum]
    raise "Invalid file checksum" unless self.tmpfile_md5_checksum == uploaded_file_checksum
    File.rename(self.tmpfile_fullpath, self.renamed_file_fullpath_by(filename))
    self.update_attribute :status, STATUS_STREAMING_DONE # File upload finished
    File.open(self.renamed_file_fullpath_by(filename)) do |file|
      self.clip = file              #Attach uploaded file to 'clip' attribute
      self.save!
    end
    self.remove_attached_data! # Remove uploaded data
  end

  private

    @@users = nil
    @@events = nil

    def set_chunk_id! chunk_id
      raise "Invalid chunk id!" unless self.last_chunk_id + 1 == chunk_id
      self.update_attribute :last_chunk_id, chunk_id
    end

end

