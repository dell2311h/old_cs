class EncodingHandler::Streaming < EncodingHandler::Base

  def perform params
    video = find_video params
    clips = update_clips video.id, params[:medias]
    send_to_thumbnalization clip[Clip::TYPE_SMALL_HIGH], video
  end

  private

    def find_video params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?
      Video.unscoped.joins(:clips).readonly(false)
                    .where("clips.encoding_id = ? AND clip_type = ? ",
                            params[:input_media_ids].first,
                            Clip::TYPE_DEMUX_VIDEO).first
    end

    def send_to_thumbnalization clip, video
      profile = EncodingProfile.find_by_name "thumbnails"
      params = { :profile_id => profile.profile_id,
                 :encoder => { :input_media_ids => [clip.encoding_id],
                               :params => { :destination => "encoded/#{video.event_id}/#{video.id}/thumbnails" }
                             }
               }
      response = Pandrino::Api.deliver Settings.encoding.url.actions.encoders, params
      raise 'Failed to send video to making thumbnails' unless response["status"] == 'ok'
    end

end