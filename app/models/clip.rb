class Clip < ActiveRecord::Base
  TYPE_DEMUX_VIDEO = 'demuxed_video'
  TYPE_DEMUX_AUDIO = 'demuxed_audio'
  TYPE_SMALL_HIGH  = '160x240_high'
  TYPE_BIG_HIGH    = '640x960_high'
  belongs_to :video

  validates :source, :encoding_id, :presence => true
  validates_presence_of :video_id

  validates :video_id, uniqueness: { :scope => :clip_type }

  after_create :add_to_pluraleyes

  def location
    "#{Settings.encoding.storage.host}/#{self.source}"
  end

  private
    def add_to_pluraleyes
      if self.clip_type == TYPE_DEMUX_AUDIO
        require 'pe_hydra'
        event = Video.unscoped.where(:id => self.video_id).first.event
        pluraleyes_project_id = event.pluraleyes_id
        hydra = PeHydra::Query.new Settings.pluraleyes.login, Settings.pluraleyes.password
        pe_media = hydra.create_media("clip ID #{self.id}", self.location, pluraleyes_project_id)
        self.update_attribute :pluraleyes_id, pe_media[:id]
        Rails.logger.info "PluralEyes media created. Media ID #{self.pluraleyes_id}"
      end
    end
end
