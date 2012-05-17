require "encoding_api/api"
module EncodingApi

  class Streaming < EncodingApi::Profile

    def process_media params
      begin
        raise 'Invalid params' if params.nil?

        url = '/encoders'
        response = EncodingApi::Api.send_request url, params, :post
        status = parse_response response
        raise 'Server returned error' unless status == true
        EncodingApi.log 'Demuxed video with encoding_id: ' + encoding_id + ' was send to streaming'

        return true
      rescue Exception => e
        EncodingApi.log 'Failed to send demuxed_video with encoding_id: ' + encoding_id + ' to streaming reason: ' + e.message

        return false
      end
    end

  end

end