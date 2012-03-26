require 'net/http'
module EncodingLib

  class Api

    def self.send_request action, params
      self.instance.send action, params
    end

    def self.instance
      @@instance = self.new if @@instance.nil?

      @@instance
    end

    def send action, params
        #url = "#{@base_url}/#{action}"
        #request = Net::HTTP::Get.new(url)

        #request
    end

    def initialize
      @base_url = "localhost"
    end

      private
         @@instance = nil
  end

end