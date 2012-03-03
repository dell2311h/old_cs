class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  respond_to :json


  rescue_from Exception do |exeption|
    respond_with :error => exeption.message, :status => :bad_request
  end

end

