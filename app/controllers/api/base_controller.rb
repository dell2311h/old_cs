class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  respond_to :json

  def api_hashes_array(array)
    array.map do |object|
      object.api_data
    end
  end

end
