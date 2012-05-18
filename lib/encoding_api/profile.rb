module EncodingApi
  class EncodingApi::Profile
      def parse_response response
        p 'PROFILE'
        raise "Can't parse response: #{response.to_json}" if response.nil? || response["status"].nil?
      
        response["status"]
      end

  end

end