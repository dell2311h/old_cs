class EncodingHandler::MetaInfo

  def perform params
    media = params["medias"][0]
    video = Video.unscoped.find_by_encoding_id media["_id"]
    meta_info = ::MetaInfo.find_or_initialize_by_video_id video.id
    meta_info.update_attributes(:duration    => media["meta_info"]["duration"],
                                :recorded_at => media["meta_info"]["create_date"],
                                :rotation    => media["meta_info"]["rotation"])
    profile = EncodingProfile.find_by_name "demux"
    params = { :profile_id => profile.profile_id,
               :encoder => { :input_media_ids => [media["_id"]],
                             :params => { :audio_destination => "encoded/#{video.event_id}/#{video.id}/demuxed/audio.wav",
                                          :video_destination => "encoded/#{video.event_id}/#{video.id}/demuxed/video.mp4"
                              }
                            }
              }
    response = Pandrino::Api.deliver Settings.encoding.url.actions.encoders, params
    raise 'Failed to send video to demux' unless response["status"] == 'ok'
  end

end