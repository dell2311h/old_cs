require "encoding_api/api"
module EncodingApi

  class Demux

    def process_media encoding_id
      begin
        raise 'Encoding_id not set' if encoding_id.nil?
        status = EncodingApi::Api.send_request :demux, { :encoding_id => encoding_id}
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