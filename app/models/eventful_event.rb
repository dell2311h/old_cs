require 'eventful/api'
class EventfulEvent

  def self.search params
    search_params = {}
    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      check_coordinates
      search_params[:within] = Settings.search.radius
      search_params[:latitude] = params[:latitude]
      search_params[:longitude] = params[:longitude]
      unless  params[:longitude].nil? || params[:latitude].nil?
        search_params[:location] = "#{params[:latitude]},#{params[:longitude]}"
      end
    end

    if params[:date]
      search_params[:date] = format_date params[:date]
    end

    if params[:event_name]
      search_params[:keywords] = params[:event_name]
    end

    unless params[:page].nil?
      search_params[:page_number] = params[:page]
      search_params[:page_size] = params[:per_page] || Settings.paggination.per_page
    end

    results = self.eventful_api.call 'events/search', search_params

    format_result  results
  end
    
    private
      @@eventful_api = nil

      def self.eventful_api
        if @@eventful_api.nil?
           @@eventful_api = Eventful::API.new Settings.eventful.app_key
        end

      @@eventful_api
      end

      def self. format_result input
        output_events = []
        return {:events => [] } if input["total_items"].nil? || input["total_items"] < 1
        events = input["events"]["event"]

        if input["total_items"] == 1
          events_array = []
          events_array.push events
          events = events_array
        end
        events.each do |event|
          tmp = {}
          tmp[:eventful_id]     = event["id"]
          tmp[:name]            = event["title"]
          tmp[:date]            = event["start_time"]
          # TODO: fix after build
          #tmp[:image_url] = nil
          #tmp[:image_url] = event["image"]["url"] unless event["image"].nil? || event["image"]["url"].nil?
          output_events.push tmp
        end

        { events: output_events, size: input["total_items"]}
      end

    def self.check_coordinates latitude, longitude
      Float(latitude)
      Float(longitude)
    end

    def self.format_date date
       date = Date.parse date
       date_begin = date - 1
       date_begin = date_begin.strftime("%Y%m%d00")
       date_end = date.strftime("%Y%m%d00")
       interval = date_begin.to_s + '-' + date_end.to_s

       interval
    end
end
