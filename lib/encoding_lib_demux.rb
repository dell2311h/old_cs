require "encoding_lib_api"
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

      def self.demux_video video
        EncodingLib::Api.send_request 'demux', video.clip.url
      end
  end
end