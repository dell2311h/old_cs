require "encoding_api/api"
module EncodingApi
  class Stream

    def process_media encoding_id
      begin
        raise 'Demux_video encoding_id not set' if encoding_id.nil?
        status = EncodingApi::Api.send_request :streaming, { :encoding_id => encoding_id}
        raise 'Server returned error' unless status == true

        EncodingApi.log 'Video encoding_id: ' + encoding_id + ' was send to streaming'

        return true
      rescue Exception => e
        EncodingApi.log 'Failed to send video encoding_id: ' + encoding_id + ' to streaming reason: ' + e.message
        return false
      end
    end

  end
end