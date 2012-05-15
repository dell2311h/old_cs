module EncodingHandler

  def self.handle(event, params)
    EncodingHandler.send(event, params)

  end

  private

    def self.meta_info params
      encoding_id = params[:data][:input_media_ids][0]
      video = Video.find_by_encoding_id encoding_id

      status = EncodingApi::Factory.process_media :demux, encoding_id
      raise 'Unable to add video to demux' unless status
    end

    def self.demux params
        #  video = Video.find_by
    #  status = EncodingApi::Factory.process_media :demux, self.encoding_id
    #  raise 'Failed to send video to demux' if !status
    #end
    #
    #def self.demux params
    #end
    #
    #def self.normalize
    #end
    #
    #def self.demux
    #      begin
    #  video = Video.find result[:video_id]
    #  media = nil
    #
    #  unless result[:demux_audio].nil?
    #    media = result[:demux_audio]
    #    clip_type = Clip::TYPE_DEMUX_AUDIO
    #    clip_other_type = Clip::TYPE_DEMUX_VIDEO
    #  end
    #  unless result[:demux_video].nil?
    #    media = result[:demux_video]
    #    clip_type = Clip::TYPE_DEMUX_VIDEO
    #    clip_other_type = Clip::TYPE_DEMUX_AUDIO
    #  end
    #
    #  raise 'demux_audio or demux_video not_set' if media.nil?
    #  raise 'media source not set' if media[:source].nil?
    #  raise 'media encoding_id not set' if media[:encoding_id].nil?
    #
    #  clip = Clip.find_or_initialize_by_video_id_and_clip_type(video.id, clip_type)
    #  clip.update_attributes({ :source      => media[:source],
    #                           :encoding_id => media[:encoding_id],
    #                           :clip_type   => clip_type,
    #                        })
    #
    #  unless clip.errors.empty?
    #    raise 'Unable to save clip errors: ' + clip.errors.to_json
    #  end
    #
    #  logger.info "Created demux clip(encoding_id #{media[:encoding_id]}) for video id# #{video.id.to_s}"
    #
    #  if video.status == Video::STATUS_DEMUX_WORKING
    #    other_clip = Clip.where(:clip_type => clip_other_type, :video_id => video.id)
    #    unless other_clip.first.nil?
    #      video.update_attributes({ :status => Video::STATUS_DEMUX_DONE })
    #      video.stream!
    #    end
    #  end
    #rescue Exception => e
    #   message = 'Failer to create clip reason: '
    #   message = 'Failer to create clip for video id# ' + result[:video_id] + ' reason: 'unless result[:video_id].nil?
    #
    #   logger.error message + e.message
    #
    #   return false, e.message
    #end
    #
    #return true, nil

    end

end