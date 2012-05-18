class EncodingHandler::Base

  protected
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
        Rails.logger.info "Created #{media["type"]} clip (encoding_id #{media[:encoding_id]}) for video id# #{video_id.to_s}"
      end
      clips
    end
end