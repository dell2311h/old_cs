class EncodingHandler::Demux

  def perform params
    video = find_video params
    clips = update_clips video.id, params[:medias]
    send_to_streaming clips["demuxed_video"], video
  end

  private

    def send_to_streaming clip, video
      profile = EncodingProfile.find_by_name "streaming"
      params = { :profile_id => profile.profile_id,
                 :encoder => { :input_media_ids => [clip.encoding_id],
                               :params => { :destination_1 => "encoded/#{video.event_id}/#{video.id}/streaming/low/160x240.mp4",
                                            :destination_2 => "encoded/#{video.event_id}/#{video.id}/streaming/normal/160x240.mp4",
                                            :destination_3 => "encoded/#{video.event_id}/#{video.id}/streaming/high/160x240.mp4",
                                            :destination_4 => "encoded/#{video.event_id}/#{video.id}/streaming/low/320x480.mp4",
                                            :destination_5 => "encoded/#{video.event_id}/#{video.id}/streaming/normal/320x480.mp4",
                                            :destination_6 => "encoded/#{video.event_id}/#{video.id}/streaming/high/320x480.mp4",
                                            :destination_7 => "encoded/#{video.event_id}/#{video.id}/streaming/low/640x960.mp4",
                                            :destination_8 => "encoded/#{video.event_id}/#{video.id}/streaming/normal/640x960.mp4",
                                            :destination_9 => "encoded/#{video.event_id}/#{video.id}/streaming/high/640x960.mp4"
                                          }
                             }
              }
      status = EncodingApi::Factory.process_media "streaming", params
      raise 'Unable to add video to demux' unless status
    end

    def update_clips video_id, medias
      clips = {}
      medias.each do |media|
        clip = Clip.find_or_initialize_by_video_id_and_clip_type(video_id, media[:type])
        clip.source      = media["location"]
        clip.encoding_id = media["_id"]
        clip.clip_type   = media["type"]
        clip.save
        raise 'Unable to save clip errors: ' + clip.errors.to_json unless clip.errors.empty?
        clips[media["type"]] = clip
        Rails.logger.info "Created demux clip(encoding_id #{media[:encoding_id]}) for video id# #{video_id.to_s}"
      end
      clips
    end

    def find_video params
      raise 'Wrong params' if params[:input_media_ids].nil? || params[:input_media_ids].first.nil?
      Video.unscoped.find_by_encoding_id! params[:input_media_ids].first
    end

end