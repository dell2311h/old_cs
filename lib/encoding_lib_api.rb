require 'net/http'
module EncodingLib

  class Api

    def self.send_request action, params
      case action
      when :add_media
        response = self.instance.request '/medias', params, :post

        return response.id
      when 'demux'
        send_params = {:command => "demux"}
        action = '/demux/' + params[:encoding_id] + '/encode'
        response = self.instance.request action, send_params, :post
        
        return true unless response.id.nil?
        
        return false

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

        raise 'Request "' + action + '" unsuccessfull params(' + (params.to_json) + ')' if response != Net::HTTPSuccess
        response = response.get_response

        response
    end

    def initialize
      uri = URI.parse(Crowdsync::Application.config.encding_url)
      @base_url = uri.host
      @port     = uri.port
    end

      private
         @@instance = nil
  end

end