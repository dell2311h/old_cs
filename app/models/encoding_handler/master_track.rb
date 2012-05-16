class EncodingHandler::MasterTrack

  def perform params

    media = get_media params

    master_track = find_master_track_by params
    master_tracks.update_attributes! :source => params[:media][:source], :encoding_id => params[:media]["_id"], :is_ready => true

    profile = EncodingProfile.find_by_name "normalize_audio"
    params = { :profile_id => profile.profile_id,
               :encoder => { :input_media_ids => [media["_id"]],
                             :params => { :destination => "encoded/#{master_track.event_id}/master_tracks/#{master_track.id}/normalized"
                              }
                            }
              }
    status = EncodingApi::Factory.process_media "normalize_audio", params
    raise 'Unable to add master_track to normalize audio levels' unless status

  end

  private

    def get_media params
      params[:medias][0]
    end

    def find_master_track_by params
      MasterTrack.find params[:special_keys][:master_track_id]
    end

end

