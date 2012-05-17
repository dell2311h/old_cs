class EncodingHandler::Streaming < EncodingHandler::Base

  def perform params
    video = find_video params
    update_clips video.id, params[:medias]

    video.status = Video::STATUS_PROCESSING_DONE
    video.save
  end

  private

    def find_video params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?

      video = Video.unscoped.join(:clip)

      video.where("clips.encoding_id = ? AND clip_type = ? ", params[:input_media_ids].first, Video::TYPE_DEMUX_VIDEO).first
    end

end