require "encoding_api/api"
module EncodingApi

  class MetaInfo < EncodingApi::Profile

    def process_media params
      begin
        raise 'Invalid params' if params.nil?

        url = '/encoders'
        response = EncodingApi::Api.send_request url, params, :post
        status = parse_response response
        raise 'Server returned error' unless status == true
        EncodingApi.log 'Video with encoding_id: ' + encoding_id + ' was send to demux'

        return true
      rescue Exception => e
        EncodingApi.log 'Failed to send video with encoding_id: ' + encoding_id + ' to demux reason: ' + e.message

        return false
      end
    end

  end

end