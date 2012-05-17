require "encoding_api/api"
module EncodingApi

  class MasterTrack < EncodingApi::Profile

    def process_media params
      begin
        raise 'Params is empty' unless params
        raise 'Encoder params is empty' unless params[:encoder]
        raise 'Destination is not provided' unless params[:encoder][:destination]
        raise 'Timings are not provided' unless params[:encoder][:cutting_timings]
        raise 'Timings are not provided' unless params[:encoder][:input_media_ids]

        url = '/encoders'
        response = EncodingApi::Api.send_request url, params, :post
        status = parse_response(response)
        raise 'Server returned error' unless status == 'processing'
        EncodingApi.log "Medias with encoding_ids: #{params[:encoder][:input_media_ids]} were send to master track creation"
        response
      rescue Exception => e
        EncodingApi.log "Send medias with encoding_ids: #{params[:encoder][:input_media_ids]} to master track creation failed by: #{e.message}"
        false
      end
    end

  end

end

