require "encoding_api/api"
module EncodingApi

  class CreateMedia

    def process_media clip_url
      begin
        encoding_id = EncodingApi::Api.send_request :add_media, {:media => {:source => clip_url} }
        EncodingApi.log 'Added video to encoding, encoding_id: ' + encoding_id

        return encoding_id
      rescue Exception => e
        EncodingApi.log 'Failed to add video  url: ' + clip_url + ' to encoding, reason: ' + e.message

        return false
      end
    end

  end

end