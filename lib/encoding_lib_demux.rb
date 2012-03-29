require "encoding_lib_api"
require 'encoding_lib_logger'
module EncodingLib

  class Demux
    def self.demux_videos
      videos_to_demux = self.find_demux_videos

      unless videos_to_demux.nil?
        videos_to_demux.each do |video_to_demux|
          self.demux_video video_to_demux
        end
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
      def self.find_demux_videos
        Video.where(:status => Video::STATUS_NEW)
      end

      def self.add_media video
        EncodingLib::Logger.log 'Adding media id# ' + video_to_demux.id.to_s
        encoding_id = EncodingLib::Api.send_request 'add_media', video.clip.url

        encoding_id
      end

      def self.demux_video video

      if video.encoding_id.nil?
        video.encoding_id = self.add_media video
        video.save
      end

        EncodingLib::Logger.log 'Demuxing video id# ' + video_to_demux.id.to_s
        status EncodingLib::Api.send_request 'demux', video.encoding_id

        if status == "OK"
          EncodingLib::Logger.log 'Video video id# ' + video_to_demux.id.to_s + 'was sent to demux'
          video.status = Video::STATUS_DEMUX_WORKING
          video.save
        else
          EncodingLib::Logger.log 'Failes to demux video id# ' + video_to_demux.id.to_s
        end
      end
  end
end