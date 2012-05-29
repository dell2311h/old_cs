require 'net/http'
module Pandrino
  class Api
    @logger = Logger.new(Rails.root.to_s + '/log/encoding_' + Rails.env + '.log')
    @base_url = Settings.encoding.url.host
    @port     = Settings.encoding.url.port

    def self.log text
        @logger.info Time::now.to_s + "\n" + text + "\n"
    end

    def self.deliver url, params, method = :post
      begin
        raise 'Wrong url' if url.nil?
        raise 'Wrong params' if params.nil?
        raise 'Wrong method' if method.nil?
        http = Net::HTTP.new(@base_url, @port)
        case method
        when :post
          request = Net::HTTP::Post.new(url)
          request.body = params.to_param
        when :get
          request = Net::HTTP::Get.new(url)
          request.body = params.to_param
        else
          raise 'unknown request method'
        end
        response = http.request(request)

        raise "Request '#{url}' unsuccessfull params(#{params.to_json})" unless response.is_a? Net::HTTPSuccess
        response = ActiveSupport::JSON.decode response.read_body
        log "Perform request with params: #{params.to_json} to #{url}"
        response
      rescue Exception => e
        log "Unable to perform request with params: #{params.to_json} to #{url} failed by: #{e.message}"
        false
      end
    end
  end
end