require 'eventful/api'
class EventfulPerformer

  def self.search params

    raise 'performer_name not set' if params[:performer_name].nil?
    search_params = {}
    search_params[:keywords] = params[:performer_name]
    unless params[:page].nil?
      search_params[:page_number ] = params[:page]
      search_params[:page_size] = (params[:per_page].nil? ? Settings.paggination.per_page : params[:per_page])
    end
    results = self.eventful_api.call 'performers/search', search_params

    self.format_result results
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
      return [] if input["total_items"] < 1
      performers = input["performers"]["performer"]

      if input["total_items"] == 1
        performers_array = []
        performers_array.push performers
        performers = performers_array
      end

      output_performers = []
      performers.each do |performer|
        tmp = {}
        tmp[:name] = performer["name"]
        tmp[:image] = performer["image"]
        output_performers.push tmp
      end

      output_performers
    end

end