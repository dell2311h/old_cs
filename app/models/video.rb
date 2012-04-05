require "encoding_api/factory"
class Video < ActiveRecord::Base

  STATUS_UPLOADING = -1
  STATUS_NEW = 0
  STATUS_DEMUX_WORKING = 1
  STATUS_DEMUX_DONE = 2
  STATUS_STREAMING_WORKING = 3
  STATUS_STREAMING_DONE = 4

  attr_accessible :clip, :event_id, :user_id, :name, :encoding_id, :status
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
    Video.joins(:clips).where('clips.encoding_id' => encoding_id).select('videos.*').first
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


#---------Encoding---------

  def demux!
    self.update_attributes( {:encoding_id => get_encoding_id} ) if self.encoding_id.nil?
    send_to_demux
    self.update_attributes( {:status => Video::STATUS_DEMUX_WORKING} )
  end

  def stream!
    raise 'Unable to stream' unless self.status == Video::STATUS_DEMUX_DONE
    status = EncodingApi::Factory.process_media :stream, self.demux_video.encoding_id
    raise 'Failed to send video to stream' if !status
    self.update_attributes( {:status => Video::STATUS_STREAMING_WORKING} )
  end

  def self.stream_ready result
    begin
      raise 'demux_video encoding_id not set' if result[:id].nil?
      video = Video.find_by_clip_encoding_id result[:id]
      raise 'Video not_found' if video.nil?
      raise 'Streaming not set' if result[:streaming].nil?
      raise 'straming source not set' if result[:streaming][:source].nil?
      raise 'streaming encoding_id not set' if result[:streaming][:encoding_id].nil?

      clip = Clip.find_or_initialize_by_video_id_and_clip_type(video.id, Clip::TYPE_STREAMING)
      clip.update_attributes({ :source      => result[:streaming][:source],
                               :encoding_id => result[:streaming][:encoding_id],
                               :clip_type   => Clip::TYPE_STREAMING,
                            })

      unless clip.errors.empty?
        raise 'Unable to save clip params: ' + clip.errors.to_json
      end

      logger.info "Created streaming clip(encoding_id #{result[:streaming][:encoding_id]}) for video id# #{video.id.to_s}"

      video.update_attributes({ :status => Video::STATUS_STREAMING_DONE }) if video.status == Video::STATUS_STREAMING_WORKING

    rescue Exception => e
      message = 'Failer to create stream reason: '
      message = 'Failer to create stream for video encoding_id# ' + result[:id] + ' reason: 'unless result[:id].nil?
      logger.error message + e.message

      return false, e.message
    end

    return true, nil
  end

  def self.demux_ready result
    begin
      video = Video.find result[:video_id]
      media = nil

      unless result[:demux_audio].nil?
        media = result[:demux_audio]
        clip_type = Clip::TYPE_DEMUX_AUDIO
        clip_other_type = Clip::TYPE_DEMUX_VIDEO
      end
      unless result[:demux_video].nil?
        media = result[:demux_video]
        clip_type = Clip::TYPE_DEMUX_VIDEO
        clip_other_type = Clip::TYPE_DEMUX_AUDIO
      end

      raise 'demux_audio or demux_video not_set' if media.nil?
      raise 'media source not set' if media[:source].nil?
      raise 'media encoding_id not set' if media[:encoding_id].nil?

      clip = Clip.find_or_initialize_by_video_id_and_clip_type(video.id, clip_type)
      clip.update_attributes({ :source      => media[:source],
                               :encoding_id => media[:encoding_id],
                               :clip_type   => clip_type,
                            })

      unless clip.errors.empty?
        raise 'Unable to save clip errors: ' + clip.errors.to_json
      end

      logger.info "Created demux clip(encoding_id #{media[:encoding_id]}) for video id# #{video.id.to_s}"

      if video.status == Video::STATUS_DEMUX_WORKING
        other_clip = Clip.where(:clip_type => clip_other_type, :video_id => video.id)
        unless other_clip.first.nil?
          video.update_attributes({ :status => Video::STATUS_DEMUX_DONE })
          video.stream!
        end
      end
    rescue Exception => e
       message = 'Failer to create clip reason: '
       message = 'Failer to create clip for video id# ' + result[:video_id] + ' reason: 'unless result[:video_id].nil?

       logger.error message + e.message

       return false, e.message
    end

    return true, nil
  end

  private
    def get_encoding_id
      id = EncodingApi::Factory.process_media :create_media, self.clip.url
      raise 'Failed to get encoding_id' if !id

      id
    end

    def send_to_demux
      status = EncodingApi::Factory.process_media :demux, self.encoding_id
      raise 'Failed to send video to demux' if !status
    end
end
