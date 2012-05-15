require "encoding_api/demux"
require "encoding_api/create_media"
require "encoding_api/stream"
module EncodingApi
  @logger = Logger.new(Rails.root.to_s + '/log/encoding_' + Rails.env + '.log')

  def self.log text
      @logger.info Time::now.to_s + "\n" + text + "\n"
  end

  class Factory

    def self.process_media action, params
      case action
      when :create_media
        processor = CreateMedia.new
      when :demux
        processor = Demux.new
      when :stream
        processor = Stream.new
      else
        raise "Unknown action"
      end
      processor.process_media params
    end

  end

end