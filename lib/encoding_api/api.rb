require 'net/http'
class EncodingApi::Api
  def self.send_request url, params, method
    raise 'Wrong url' if url.nil?
    raise 'Wrong params' if params.nil?
    raise 'Wrong method' if method.nil?

    self.instance.request url, params, method
  end

  def self.instance
    @@instance = self.new if @@instance.nil?

    @@instance
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