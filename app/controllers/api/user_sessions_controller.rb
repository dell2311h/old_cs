class Api::UserSessionsController < Api::BaseController

  skip_before_filter :auth_check, :only => [:create]

  def create
    if params[:email]
      @user = User.find_by_email(params[:email])
      raise "Wrong email or password" if @user.nil? or !@user.valid_password? params[:password]
    elsif params[:provider]
      @auth = Authentication.find_by_provider_and_uid(params[:provider], params[:uid])
      raise "Can't find user with #{params[:provider]} provider" unless @auth
      unless @auth.token == params[:token]
        raise "Token for #{params[:provider]} provider incorrect" unless @auth.correct_token?(params[:token])
        @auth.update_attribute(:token, params[:token])
      end
      @user = @auth.user
    else
      raise "Not enough options for authorization"
    end

    sign_in @user

    render status: :ok, json: { token: @token }
  end

end

