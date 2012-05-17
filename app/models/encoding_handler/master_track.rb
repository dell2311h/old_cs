class EncodingHandler::MasterTrack

  def perform params

    media = get_media params
    master_track = find_master_track_by params
    master_track.update_attributes! :source => full_location_of(media), :is_ready => true

  end

  private

    def get_media params
      params[:medias][0]
    end

    def find_master_track_by params
      ::MasterTrack.find_by_encoder_id! params[:encoder_id]
    end

    def full_location_of(media)
      "#{Settings.aws_s3.host}/#{Settings.aws_s3.bucket}/#{media["location"]}"
    end

end

