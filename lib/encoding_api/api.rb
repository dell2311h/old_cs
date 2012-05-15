require 'net/http'
module EncodingApi

  class Api

    def self.send_request action, params
      case action
      when :add_media
        response = self.instance.request '/medias', params, :post

        return response["media"]["id"]
      when :demux
        send_params = {:command => "demux"}
        action = '/medias/' + params[:encoding_id] + '/encode'
        response = self.instance.request action, send_params, :post

        return true

      when :streaming
        send_params = {:command => "streaming"}
        action = '/medias/' + params[:encoding_id] + '/encode'
        response = self.instance.request action, send_params, :post

        return true
      else
        raise 'unknown action'
      end
    end

    def self.instance
      @@instance = self.new if @@instance.nil?

      @@instance
    end

    def parse_result result

      result
    end

    def request action, params, method
        case method
        when :post
        http = Net::HTTP.new(@base_url, @port)
        request = Net::HTTP::Post.new(action)
        request.body = params.to_param
        response = http.request(request)
        else
          raise 'unknown request method'
        end

        raise 'Request "' + action + '" unsuccessfull params(' + (params.to_json) + ')' unless response.is_a? Net::HTTPSuccess
        response = ActiveSupport::JSON.decode response.read_body

        response
    end

    def initialize
      @base_url = Settings.encoding.url.host
      @port     = Settings.encoding.url.port
    end

      private
         @@instance = nil
  end

end