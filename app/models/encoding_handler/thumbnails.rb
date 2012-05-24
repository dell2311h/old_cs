class EncodingHandler::Thumbnails < EncodingHandler::Base

  def perform params
    video = find_video params
    update_clips video.id, params[:medias]
    video.status = Video::STATUS_PROCESSING_DONE
    video.save
  end

  private

    def find_video params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?
      Video.unscoped.joins(:clips).readonly(false)
                    .where("clips.encoding_id = ? AND clip_type = ? ",
                            params[:input_media_ids].first,
                            Clip::TYPE_SMALL_HIGH).first
    end

end
