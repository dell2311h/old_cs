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
      raise 'video_id not set' if result[:video_id].nil?
      raise 'demux_audio not set' if result[:demux_audio].nil?
      raise 'demux audio source not set' if result[:demux_audio][:source].nil?
      raise 'demux audio encoding_id  not set' if result[:demux_audio][:encoding_id].nil?
      raise 'demux_video not set' if result[:demux_video].nil?
      raise 'demux video source not set' if result[:demux_video][:source].nil?
      raise 'demux video encoding_id  not set' if result[:demux_video][:encoding_id].nil?
      
      video = Video.find result[:video_id]
      raise 'video not found' if video.nil?

      demux_audio = Clip.find_or_initialize_by_video_id_and_clip_type(video.id, Clip::TYPE_DEMUX_AUDIO)
      demux_audio.update_attributes({ :source      => result[:demux_audio][:source],
                                      :encoding_id => result[:demux_audio][:encoding_id],
                                      :clip_type   => Clip::TYPE_DEMUX_AUDIO,
                                    })

      demux_video = Clip.find_or_initialize_by_video_id_and_clip_type(video.id, Clip::TYPE_DEMUX_VIDEO)
      demux_video.update_attributes({ :source      => result[:demux_video][:source],
                                      :encoding_id => result[:demux_video][:encoding_id],
                                      :clip_type   => Clip::TYPE_DEMUX_VIDEO
                                    })

      unless demux_video.errors.empty? && demux_audio.errors.empty?
        raise 'Validation errors'
      end
      video.status = Video::STATUS_DEMUX_DONE
      video.save
      EncodingLib::Logger.log "Created demux audio(encoding_id #{result[:demux_audio][:encoding_id]}) and video #{result[:demux_video][:encoding_id]}) for video id# #{video.id.to_s}"

      true
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