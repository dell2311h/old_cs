class Clip < ActiveRecord::Base
  TYPE_DEMUX_VIDEO = 'demux_video'
  TYPE_DEMUX_AUDIO = 'demux_audio'
  TYPE_STREAMING   = 'streaming'
  belongs_to :video

  validates :source, :encoding_id, :presence => true
  validates_presence_of :video_id

  validates :video_id, uniqueness: { :scope => :clip_type }

  after_create :add_to_pluraleyes

  private
    def add_to_pluraleyes
      if self.clip_type == TYPE_DEMUX_AUDIO
        require 'pe_hydra'
        event = self.video.event
        pluraleyes_project_id = event.pluraleyes_id
        hydra = PeHydra::Query.new Settings.pluraleyes.login, Settings.pluraleyes.password
        pe_media = hydra.create_media("clip ID #{self.id}", self.source, pluraleyes_project_id)
        self.update_attribute :pluraleyes_id, pe_media[:id]
        Rails.logger.info "PluralEyes media created. Media ID #{self.pluraleyes_id}"
        Resque.enqueue(Worker::TimingsInterpretator, event.id) if event.sync_with_pluraleyes?
      end
    end


end

