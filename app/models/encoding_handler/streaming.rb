class EncodingHandler::Streaming

  def perform params
    video = find_video params
    medias = get_medias params
    update_clips video.id, Clip::TYPE_DEMUX_AUDIO, medias[:audio]
    clip = update_clips video.id, Clip::TYPE_DEMUX_VIDEO, medias[:video]

    video.status = Video::STATUS_PROCESSING_DONE

    video.save
  end

  private

    def update_clips video_id, type, media
      clip = Clip.find_or_initialize_by_video_id_and_clip_type(video_id, type)
      clip.update_attributes({ :source      => media[:source],
                               :encoding_id => media[:encoding_id],
                               :clip_type   => type,
                            })

      raise 'Unable to save clip errors: ' + clip.errors.to_json unless clip.errors.empty?
      clip.save
      Rails.logger.info "Created demux clip(encoding_id #{media[:encoding_id]}) for video id# #{video_id.to_s}"

      clip
    end

    def get_medias params
      audio = nil
      video = nil

      params[:medias].each do |media|
        tmp = {}
        tmp[:source] = media["location"]
        tmp[:encoding_id] = media["_id"]
        audio = tmp if media["type"] == 'audio'
        video = tmp if media["type"] == 'video'
      end

      raise 'Unable to get medias' if audio.nil? || video.nil?

      { :audio =>audio, :video => video }
    end

    def find_video params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?

      Video.unscoped.find_by_encoding_id! params[:input_media_ids].first
    end

end