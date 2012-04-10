class FoursquarePlace

  def self.find params
    search_params = {}
    raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
    check_coordinates params[:latitude], params[:longitude]
    search_params[:ll] = "#{params[:latitude]},#{params[:longitude]}"
    search_params[:radius] = self.cast_radius Settings.search.radius

    if params[:place_name]
      search_params[:query] = params[:place_name]
    end

    raise 'Invalid  search params provided' if search_params.empty?

    places =  self.foursuare_api.search_venues search_params

    format_result places
  end

  private

    def self.format_result input
      output_places = []

      places = input["groups"][0]["items"]

      places.each do |place|
        tmp = {}
        tmp[:foursquare_id] = place["id"]
        tmp[:name]          = place["name"]
        tmp[:latitude]      = place["location"]["lat"]
        tmp[:longitude]     = place["location"]["lng"]
       
        output_places.push tmp
      end

      output_places
    end

    def self.check_coordinates latitude, longitude
      Float(latitude)
      Float(longitude)
    end

    def self.cast_radius radius
      radius = 1609.344 * radius
      radius = 100000 if radius > 100000

      radius
    end

    @@foursquare_api = nil

    def self.foursuare_api
      if @@foursquare_api.nil?
         @@foursquare_api = Foursquare2::Client.new(:client_id     => Settings.foursuare.client_id,
                                                    :client_secret => Settings.foursuare.client_secret)
      end

      @@foursquare_api
    end
end
