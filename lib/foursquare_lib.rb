module ForsquareLib

  class Api

    def self.find_places search_params
      unless search_params[:latitude].nil?
        latitude  = search_params[:latitude]
        search_params.delete :latitude
      end      
      unless search_params[:longitude].nil?
        longitude = search_params[:longitude]
        search_params.delete :longitude
      end

      unless longitude.nil? && latitude.nil?
        search_params[:ll] = "#{latitude},#{longitude}"
      end
      
      if search_params[:radius]
        search_params[:radius] = self.cast_radius search_params[:radius]
      end

      results = self.foursuare_api.search_venues search_params

      output_places = []

      places = results["groups"][0]["items"]

      places.each do |place|
        tmp = {}
        tmp[:foursquare_id] = place["id"]
        tmp[:name]          = place["name"]
        tmp[:latitude]      = place["location"]["lat"]
        tmp[:longitude]     = place["location"]["lng"]
       
        output_places.push tmp
      end

      out = {}
      out[:places] = output_places
      out[:count] = output_places.count

      out
    end

    private

    def self.cast_radius radius
      radius = 1609.344 * radius
      radius = 100000 if radius > 100000

      radius
    end

    @@foursquare_api = nil
    
    def self.foursuare_api
      if @@foursquare_api.nil?
         @@foursquare_api = Foursquare2::Client.new(:client_id => Crowdsync::Application.config.foursuare_client_id,
                                                    :client_secret => Crowdsync::Application.config.foursuare_client_secret)
      end

      @@foursquare_api
    end

  end
end
