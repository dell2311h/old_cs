require "encoding_lib_api"
require 'encoding_lib_logger'
module EncodingLib

  class Demux

    def self.process_media video

      if video.encoding_id.nil?
        status = self.add_media video

        return false if status == false
      end

      begin
        status = EncodingLib::Api.send_request 'demux', { :encoding_id => video.encoding_id}

        raise 'Server returned error' unless status == true

        EncodingLib::Logger.log 'Video id# ' + video.id.to_s + ' was send to demux'
        video.status = Video::STATUS_DEMUX_WORKING
        video.save
      rescue Exception => e
        EncodingLib::Logger.log 'Failed to send video id# ' + video.id.to_s + ' to demux reason: ' + e.message
      end
    end

    def self.demux_callback result
      begin
        raise 'video_id not set' if result[:video_id].nil?
        media = nil

        unless result[:demux_audio].nil?
          media = result[:demux_audio]
          clip_type = Clip::TYPE_DEMUX_AUDIO
          clip_other_type = Clip::TYPE_DEMUX_VIDEO
        end
        unless result[:demux_video].nil?
          media = result[:demux_video]
          clip_type = Clip::TYPE_DEMUX_VIDEO
          clip_other_type = Clip::TYPE_DEMUX_AUDIO
        end

        raise 'demux_audio or demux_video not_set' if media.nil?
        raise 'media source not set' if media[:source].nil?
        raise 'media audio encoding_id  not set' if media[:encoding_id].nil?

        video = Video.find result[:video_id]
        raise 'video not found' if video.nil?

        clip = Clip.find_or_initialize_by_video_id_and_clip_type(video.id, clip_type)
        clip.update_attributes({ :source      => media[:source],
                                 :encoding_id => media[:encoding_id],
                                 :clip_type   => clip_type,
                              })

        unless clip.errors.empty?
          raise 'Unable to save clip params: ' + clip.attributes.to_json
        end

        EncodingLib::Logger.log "Created demux clip(encoding_id #{media[:encoding_id]}) for video id# #{video.id.to_s}"

        if video.status == Video::STATUS_DEMUX_WORKING
          other_clip = Clip.where(:clip_type => clip_other_type, :video_id => video.id)
          unless other_clip.first.nil?
            video.status = Video::STATUS_DEMUX_DONE
            video.save
          end
        end
      rescue Exception => e
         message = 'Failer to create clip reason: '
         message = 'Failer to create clip for video id# ' + result[:video_id] + ' reason: 'unless result[:video_id].nil?

         EncodingLib::Logger.log message + e.message

         return false, e.message
      end

      return true, nil
    end

    private


      def self.add_media video
        begin
          encoding_id = EncodingLib::Api.send_request :add_media, {:media => {:source => video.clip.url} }
          video.encoding_id = encoding_id
          video.save
          EncodingLib::Logger.log 'Added video id# ' + video.id.to_s + ' to encoding, encoding_id ' .encoding_id

          return true
        rescue Exception => e
          EncodingLib::Logger.log 'Failed to add media id# ' + video.id.to_s + ' reason: ' + e.message

          return false
        end
      end
  end
end