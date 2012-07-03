class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :auth_check

  respond_to :json

  rescue_from Exception do |exeption|
    error = case exeption.class.name
      when 'Errno::ECONNREFUSED'
        { :status => :internal_server_error, :message => I18n.t('errors.parameters.remote_service_unavailable') }
      when 'ActiveRecord::RecordNotFound'
        { :status => :not_found, :message => exeption.message }
      else
        { :status => :bad_request, :message => exeption.message }
    end

    render :status => error[:status], :json => { :error => error[:message] }, :layout => false
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

