class Clip < ActiveRecord::Base
  TYPE_DEMUX_VIDEO = 'demuxed_video'
  TYPE_DEMUX_AUDIO = 'demuxed_audio'
  TYPE_SMALL_HIGH  = '160x240_high'
  TYPE_BIG_HIGH    = '640x960_high'

  belongs_to :video

  validates :source, :encoding_id, :video_id, :presence => true

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
        pe_media = hydra.create_media("clip ID #{self.id}", nil, pluraleyes_project_id)
        response = hydra.add_audio("#{Settings.encoding.storage.location}#{self.source}", {:project_id => pluraleyes_project_id, :media_id => pe_media[:id]})
        if response == "OK"
          new_pluraleyes_group_count = hydra.sync(pluraleyes_project_id).count
          if new_pluraleyes_group_count > 0 && new_pluraleyes_group_count < event.pluraleyes_group_count
            notify_observers(:after_create_bridge)
          end
          event.update_attribute(:pluraleyes_group_count, new_pluraleyes_group_count)
        end
        self.update_attribute :pluraleyes_id, pe_media[:id]
        Rails.logger.info "PluralEyes media created. Media ID #{self.pluraleyes_id}"
      end
    end
end

