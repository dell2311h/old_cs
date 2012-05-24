class EncodingHandler::Rotate < EncodingHandler::Base

  def perform params
    clip  = find_video params
    video = Video.unscoped.find clip.video_id
    send_to_streaming(clip, video)
  end

  private

    def send_to_rotate clip, angle
      profile = EncodingProfile.find_by_name "rotate"
      params = { :profile_id => profile.profile_id,
                 :encoder => { :input_media_ids => [clip.encoding_id], :params => { :angle => angle }}
               }
    end

    def find_video params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?
      Video.unscoped.find_by_encoding_id! params[:input_media_ids].first
    end

end