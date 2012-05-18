require "encoding_api/api"
module EncodingApi

  class AddMedia < EncodingApi::Profile

    def process_media params
      begin
        url = '/medias'
        response = EncodingApi::Api.send_request url, params, :post
        encoding_id = parse_response response
        EncodingApi.log 'Added video to encoding, encoding_id: ' + encoding_id
        return encoding_id
      rescue Exception => e
        EncodingApi.log 'Failed to add video  url: ' + clip_url + ' to encoding, reason: ' + e.message

        return false
      end
    end

    def parse_response response
      raise "Can't parse response: #{response.to_json}" if response.nil? || response["media"].nil? || response["media"]["id"].nil?

      return response["media"]["id"]
    end

  end
end