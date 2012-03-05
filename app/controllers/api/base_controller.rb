class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  respond_to :json


  rescue_from Exception do |exeption|
    error = {:error => exeption.message}
    respond_with error, :status => :bad_request
  end

end

