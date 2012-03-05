class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :auth_user_check
  
  respond_to :json


  rescue_from Exception do |exeption|
    error = {:error => exeption.message}
    respond_with error, :status => :bad_request
  end
  
  protected
    def auth_user_check
      @current_user = User.first
    end

end

