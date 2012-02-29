class Api::BaseController < ApplicationController
 
  def api_hashes_array(array)
    result = array.map do |object|
      object.api_data
    end
  end
  
end
