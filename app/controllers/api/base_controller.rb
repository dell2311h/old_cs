class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :auth_check

  respond_to :json

  rescue_from Exception do |exeption|
    status = (exeption.class == ActiveRecord::RecordNotFound) ? :not_found : :bad_request
    render status: status, json: { error: exeption.message }, layout: false
  end

  private

    def current_user
      @current_user ||= User.find_by_authentication_token(params[:authentication_token])
    end

    def current_user=(user)
      @current_user = user
    end

    def sign_in(user)
      @token = user.authentication_token
      self.current_user= user
    end

    def check_coordinates_format
      Float(params[:latitude])
      Float(params[:longitude])
    end

    def auth_check
      render status: :unauthorized, json: { error: "Authentication failed" } unless current_user
    end

    def me?
      request.url =~ /api\/me/
    end




end

