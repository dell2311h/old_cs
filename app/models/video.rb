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

  validates_attachment_presence :clip
  validates_attachment_content_type :clip, :content_type => ['video/mp4', 'video/quicktime']

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

end
