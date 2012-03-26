module EncodingLib

  class Api

    def self.send_request action, params
      #self.instance.send action
      #instance = EncodingLib::Api.new
      #instance.send
      instance = self.instance
      instance.send params
    end


      
      def self.instance
        @@instance = self.new if @@instance.nil?

        @@instance
      end

      def send params
        p params
      end

      def initialize

      end

      private
         @@instance = nil
  end

end