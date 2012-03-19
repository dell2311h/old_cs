require 'eventful/api'
module EventfulLib

  class Api

    def self.create_event params
      return self.eventful_api.call 'events/new', params
    end

    def self.get_event id
      return self.eventful_api 'events/get', id
    end

    def self.find_events search_params

      unless search_params[:latitude].nil?
        latitude  = search_params[:latitude]
        search_params.delete :latitude
      end
      unless search_params[:longitude].nil?
        longitude = search_params[:longitude]
        search_params.delete :longitude
      end

      unless longitude.nil? && latitude.nil?
        search_params[:location] = "#{latitude},#{longitude}"
      end

      results = self.eventful_api.call 'events/search', search_params
      output_events = []
      return [] if results["total_items"] < 1
      events = results["events"]["event"]
      
      if results["total_items"] == 1
        events_array = []
        events_array.push events
        events = events_array
      end
      events.each do |event|
        tmp = {}
        tmp[:eventful_id]     = event["id"]
        tmp[:name]            = event["title"]
        tmp[:date]            = event["created"]
        tmp[:image_url] = nil
        tmp[:image_url] = event["image"]["url"] unless event["image"].nil? || event["image"]["url"].nil?
        output_events.push tmp
      end

      out = {}
      out[:events] = output_events
      out[:count] = results["total_items"]

      out
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