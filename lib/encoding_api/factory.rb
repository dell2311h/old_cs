require "encoding_api/profile"
require "encoding_api/demux"
require "encoding_api/add_media"
require "encoding_api/master_track"

module EncodingApi
  @logger = Logger.new(Rails.root.to_s + '/log/encoding_' + Rails.env + '.log')

  def self.log text
    @logger.info Time::now.to_s + "\n" + text + "\n"
  end

  class Factory

    def self.process_media action, params
      processor = "EncodingApi::#{action.camelize}".constantize.new

      processor.process_media params
    end

  end

end

