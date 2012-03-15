require 'eventful/api'
module EventfulLib

  class Api

    def self.create_event params
      return self.eventful_api.call 'events/new', params
    end

    def self.get_event id
      return self.eventful_api 'events/get', id
    end
    
    private
    @@eventful_api = nil

    def self.eventful_api
      if @@eventful_api.nil?
        @@eventful_api = Eventful::API.new Crowdsync::Application.config.eventful_app_key
      end

      @@eventful_api
    end

  end

end