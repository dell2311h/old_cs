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
        status EncodingLib::Api.send_request 'demux', video.clip.url

        if status = "OK"
          EncodingLib::Logger.log 'Video video id# ' + video_to_demux.id.to_s + 'was sent to demux'
          video.status = Video::STATUS_DEMUX_WORKING
          video.save
        else
          EncodingLib::Logger.log 'Failes to demux video id# ' + video_to_demux.id.to_s
        end
      end
  end
end