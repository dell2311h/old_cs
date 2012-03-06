class Api::UserSessionsController < Api::BaseController

  def create
    raise "Not enough options for authorization" if incorrect_params?
    if params[:login]
      @user = User.find_for_database_authentication(params)
      raise "Wrong username or password" if @user.nil? or !@user.valid_password? params[:password]
      @user.reset_authentication_token! if @user.authentication_token.nil?
      @response = {token: @user.authentication_token}
      @status = 200
    elsif params[:provider]
      @auth = Authentication.find_by_provider_and_uid(params[:provider], params[:uid])
      raise "Can't find user with #{params[:provider]} provider" unless @auth
      unless @auth.token == params[:token]
        raise "Token for #{params[:provider]} provider incorrect" unless @auth.correct_token?(params[:token])
        @auth.update_attribute(:token, params[:token])
      end
      @status = 200
      @response = {token: @auth.user.authentication_token}
    end
  rescue Exception => e
    @response = {error: e.message}
    @status = 400
  ensure
    respond_with(@response, :status => @status, :location => nil)
  end

private

  def incorrect_params?
    (params[:login].blank? or params[:password].blank?) and
    (params[:provider].blank? or params[:uid].blank? or  params[:token].blank?)
  end

end