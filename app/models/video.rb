class Video < ActiveRecord::Base

  STATUS_UPLOADING = -1
  STATUS_NEW = 0
  STATUS_DEMUX_WORKING = 1
  STATUS_DEMUX_DONE = 2
  STATUS_STREAMING_WORKING = 3
  STATUS_STREAMING_DONE = 4

  attr_accessible :clip, :event_id, :user_id, :uuid, :tags, :songs, :thumbnail
  has_attached_file :clip, PAPERCLIP_STORAGE_OPTIONS

  has_attached_file :thumbnail, {:styles => { :iphone => "200x200>" }}.merge(PAPERCLIP_STORAGE_OPTIONS)
  validates_attachment_content_type :thumbnail, :content_type => ['image/jpeg', 'image/pjpeg', 'image/png', 'image/gif']

  validates :user_id , :event_id, :uuid, :presence => true
  validates :user_id, :event_id, :numericality => { :only_integer => true }

  validates_attachment_presence :clip, :unless => Proc.new { |video| video.status == STATUS_UPLOADING }
  validates_attachment_content_type :clip, :content_type => ['video/mp4', 'video/quicktime'], :unless => Proc.new { |video| video.status == STATUS_UPLOADING }

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

  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }
  scope :for_user, lambda {|user| where("user_id = ?", user.id) }

  self.per_page = Settings.paggination.per_page

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => self.name,
      "size" => self.clip.size,
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

  def self.find_videos params
    videos = Video

    if params[:user_id]
      videos = videos.where(:user_id => params[:user_id])
    end

    if params[:event_id]
      videos = videos.where(:event_id => params[:event_id])
    end

    if params[:song_id]
      song = Song.find params[:song_id]
      videos = song.videos
    end

    if params[:q]
      videos = Video.with_name_like(params[:q])
    end

    videos
  end

  def add_songs songs_params
    songs_params.each do |song_params|
      song = song_params[:id] ? Song.find(song_params[:id]) : Song.create!(song_params)
      self.songs << song if !self.songs.find_by_id(song)
    end
    self.songs
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

  def append_chunk_to_file! chunk_id, chunk_binary
    raise "Upload already finalized" unless self.status == STATUS_UPLOADING
    self.set_chunk_id! chunk_id
    File.open(self.tmpfile_fullpath, 'ab') { |file| file.write(chunk_binary) }
  end

  def set_chunk_id! chunk_id
    raise "Invalid chunk id!" unless self.last_chunk_id + 1 == chunk_id
    self.update_attribute :last_chunk_id, chunk_id
  end

  def tmpfile_md5_checksum
    Digest::MD5.hexdigest(File.read(self.tmpfile_fullpath))
  end

  def tmpfile_size
    File.size self.tmpfile_fullpath
  end

  def finalize_upload_by_checksum! uploaded_file_checksum
    raise "Invalid file checksum" unless self.tmpfile_md5_checksum == uploaded_file_checksum
    self.update_attribute :status, STATUS_NEW # File upload finished
    self.update_attribute :clip, File.read(self.tmpfile_fullpath) # Attach uploaded file to 'clip' attribute
    self.remove_attached_data! # Remove uploaded data
  end

end

