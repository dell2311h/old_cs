class Api::BaseController < ApplicationController

  ITEMS_PER_PAGE = 20 # this constant is used for pagination
  
  def api_hashes_array(array)
    result = array.map do |object|
      object.api_data
    end
  end
  
end
