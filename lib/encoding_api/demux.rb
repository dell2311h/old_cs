require "encoding_api/api"
module EncodingApi

  class Demux < EncodingApi::Profile

    def process_media encoding_id, profile_id, destination
      begin
        raise 'Encoding_id not set' if encoding_id.nil?
        raise 'Profile_id not set' if profile_id.nil?
        raise 'Destination not set' if destination.nil?

        params = format_params encoding_id
        url = '/encoders'
        response = EncodingApi::Api.send_request url, format_params, :post
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