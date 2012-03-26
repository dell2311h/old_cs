require "encoding_lib_demux"
module EncodingLib

  class Worker

    def run
      EncodingLib::Demux.demux_videos
    end
  end
end