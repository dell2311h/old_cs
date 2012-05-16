require "encoding_api/api"
module EncodingApi

  class Demux < EncodingApi::Profile

    def process_media params
      begin
        raise 'Wrong params for demux' if params.nil?

        url = '/encoders'
        response = EncodingApi::Api.send_request url, params, :post
        status = parse_response response
        raise 'Server returned error' unless status == 'processing'
        EncodingApi.log "Video with encoding_id: #{params[:encoder][:input_media_ids][0]} was send to demux"

        return true
      rescue Exception => e
        EncodingApi.log "Failed to send video with encoding_id: #{params[:encoder][:input_media_ids][0]} to demux reason: #{e.message}"

        return false
      end
    end

  end

end