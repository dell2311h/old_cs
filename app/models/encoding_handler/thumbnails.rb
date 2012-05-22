class EncodingHandler::Thumbnails < EncodingHandler::Base

  def perform params
    video = find_video params
    update_clips video.id, params[:medias]
  end

  private

    def find_video params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?
      Video.unscoped.joins(:clips).readonly(false)
                    .where("clips.encoding_id = ? AND clip_type = ? ",
                            params[:input_media_ids].first,
                            Clip::TYPE_DEMUX_VIDEO).first
    end

end

