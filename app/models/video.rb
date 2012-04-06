class Video < ActiveRecord::Base

  STATUS_UPLOADING = -1
  STATUS_NEW = 0
  STATUS_DEMUX_WORKING = 1
  STATUS_DEMUX_DONE = 2
  STATUS_STREAMING_WORKING = 3
  STATUS_STREAMING_DONE = 4

  attr_accessible :clip, :event_id, :user_id, :name
  has_attached_file :clip, PAPERCLIP_STORAGE_OPTIONS


  validates :user_id , :event_id, :presence => true
  validates :user_id, :event_id, :numericality => { :only_integer => true }

  validates_attachment_presence :clip, :unless => Proc.new { |video| video.status == STATUS_UPLOADING }
  validates_attachment_content_type :clip, :content_type => ['video/mp4', 'video/quicktime'], :unless => Proc.new { |video| video.status == STATUS_UPLOADING }

  before_create do |video|
    video.name = video.clip_file_name if video.name.blank?
  end

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
  
  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

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

  #----- Chunked uploading ---------------
  
  after_create do |video| 
    # Prepare upload folder
    video.make_uploads_folder
  end
  
  after_destroy do |video|  
    # Remove uploaded data
    video.remove_attached_data 
  end
  
  TMPFILES_DIR = "#{::Rails.root}/tmp/uploads"
  UPLOADS_FOLDER = TMPFILES_DIR + "/videos"
  
  def directory_fullpath
    UPLOADS_FOLDER + "/#{self.id}"
  end
  
  def tmpfile_fullpath
    "#{directory_fullpath}/tmpfile"
  end
  
  def make_uploads_folder
    Dir.mkdir(TMPFILES_DIR) unless File.directory? TMPFILES_DIR # create dir if it is not exist
    Dir.mkdir(UPLOADS_FOLDER) unless File.directory? UPLOADS_FOLDER # create dir if it is not exist          
    Dir.mkdir(self.directory_fullpath) unless File.directory? self.directory_fullpath # create dir if it is not exist   
  end
  
  def remove_attached_data
    FileUtils.rm_rf self.directory_fullpath
  end

end
