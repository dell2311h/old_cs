class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :auth_check

  respond_to :json


  rescue_from Exception do |exeption|
    render status: :bad_request, json: { error: exeption.message }, layout: false
  end

  # TODO here should be before_filer which will be set @current_user variable with current API user object

  private

    def check_coordinates_format
      Float(params[:latitude])
      Float(params[:longitude])
    end

    def auth_check
      @current_user = User.find_by_authentication_token(params[:authentication_token])
      render status: :unauthorized, json: { error: "Authentication failed" } unless @current_user
    end
    
    def me?
      request.url =~ /api\/me/
    end

end
