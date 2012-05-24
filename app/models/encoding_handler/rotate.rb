class EncodingHandler::Rotate < EncodingHandler::Base

  def perform params
    clip  = find_clip params
    video = Video.unscoped.find clip.video_id
    send_to_streaming(clip, video)
  end

  private

    def find_clip params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?
      Clip.find_by_encoding_id! params[:input_media_ids].first
    end

end