require 'eventful/api'
class EventfulPerformer

  def self.search params

    raise 'performer_name not set' if params[:performer_name].nil?
    search_params = {}
    search_params[:keywords] = params[:performer_name]
    unless params[:page].nil?
      search_params[:page_number] = params[:page]
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

    def self.format_result input
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
        tmp[:picture_url] = get_deep_hash_value(performer, ["image", "medium", "url"])
        output_performers.push tmp
      end

      output_performers
    end

    def self.get_deep_hash_value(hash, keys)
      value = nil
      tmp_hash = hash
      last_key_index = keys.size - 1
      keys.each_with_index do |key, index|
        if tmp_hash.has_key?(key) && (tmp_hash[key].is_a?(Hash) && (index < last_key_index))
          tmp_hash = tmp_hash[key]
        elsif index == last_key_index
          value = tmp_hash[key]
        else
          break
        end
      end
      value
    end

end

