require "encoding_lib_api"
require 'encoding_lib_logger'
module EncodingLib
  class Streaming

    def self.streaming_callback result
      begin
        raise 'demux_video id not set' if result[:id].nil?
        video = Video.find_by_clip_encoding_id result[:id]
        raise 'Parent video not_found' if video.nil?
        raise 'Streaming not set' if result[:streaming].nil?
        raise 'straming source not set' if media[:source].nil?
        raise 'streaming audio encoding_id not set' if media[:encoding_id].nil?

        clip = Clip.find_or_initialize_by_video_id_and_clip_type(video.id, Clip::TYPE_STREAMING)
        clip.update_attributes({ :source      => media[:source],
                                 :encoding_id => media[:encoding_id],
                                 :clip_type   => clip_type,
                              })

        unless clip.errors.empty?
          raise 'Unable to save clip params: ' + clip.attributes.to_json
        end

        EncodingLib::Logger.log "Created streaming clip(encoding_id #{media[:encoding_id]}) for video id# #{video.id.to_s}"

        if video.status == Video::STATUS_STREAMING_WORKING
          video.status = Video::STATUS_STREAMING_DONE
          video.save
          end
        end
      rescue Exception => e
         message = 'Failer to create stream reason: '
         message = 'Failer to create stream for video id# ' + result[:id] + ' reason: 'unless result[:id].nil?

         EncodingLib::Logger.log message + e.message

         return false, e.message
      end

      return true, nil
    end
    end

    def self.process_media video
      begin
        demux_video = video.demux_video
        raise 'Demux video not found for video id#' + video.id.to_s if demux_video.nul?        
        status = EncodingLib::Api.send_request :streaming, { :media_id => demux_video.encoding_id}
        raise 'Server returned error' unless status == true

        EncodingLib::Logger.log 'Video id# ' + video.id.to_s + ' was send to streaming'
        video.status = Video::STATUS_STREAMING_WORKING
        video.save
      rescue Exception => e
        EncodingLib::Logger.log 'Failed to send video id# ' + video.id.to_s + ' to streaming reason: ' + e.message
      end
      rescue Exception => e
      end
    end

  end
end