class EncodingHandler::Demux < EncodingHandler::Base

  def perform params
    video = find_video params
    clips = update_clips video.id, params[:medias]
    angle = video.meta_info.rotation
    angle == 0 ? send_to_streaming(clips["demuxed_video"], video) : send_to_rotate(clips["demuxed_video"], angle)
  end

  private

    def send_to_rotate clip, angle
      profile = EncodingProfile.find_by_name "rotate"
      params = { :profile_id => profile.profile_id,
                 :encoder => { :input_media_ids => [clip.encoding_id], :params => { :angle => angle }}
               }
      response = Pandrino::Api.deliver Settings.encoding.url.actions.encoders, params
      raise 'Failed to send video to rotate' unless response["status"] == 'ok'
    end

    def find_video params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?
      Video.unscoped.find_by_encoding_id! params[:input_media_ids].first
    end

end
