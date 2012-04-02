require "encoding_lib_demux"
module EncodingLib

  class Worker

  def self.callback action, params
    case action
    when :demux
      status, message = EncodingLib::Demux.demux_callback params

      return status, message
    else

      return false, "unknown action"
    end
  end

    def run
      medias = find_medias

      unless medias.nil?
        medias.each do |media|
          case media.status
            when Video::STATUS_NEW
              EncodingLib::Demux.process_media media
          end

        end
      end
    end

    def find_medias
        Video.where("status = ? OR status = ?", Video::STATUS_NEW, Video::STATUS_DEMUX_DONE)
    end

  end

end