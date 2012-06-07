class EncodingHandler::MasterTrack

  def perform params

    media = get_media params
    master_track = find_master_track_by params
    master_track.update_attributes! :source => media["location"], :is_ready => true
    event = master_track.event
    event.update_attribute :master_track_version, master_track.version

  end

  private

    def get_media params
      params[:medias][0]
    end

    def find_master_track_by params
      ::MasterTrack.find_by_encoder_id! params[:encoder_id]
    end

end
