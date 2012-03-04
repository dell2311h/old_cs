class Api::UserSessionsController < Api::BaseController

  def create
    raise "Not enough options for authorization" if incorrect_params?
    @user = User.find_for_database_authentication(params)
    raise "Wrong username or password" if @user.nil? or !@user.valid_password? params[:password]
    @user.reset_authentication_token! if @user.authentication_token.nil?
    @response = {token: @user.authentication_token}
    @status = 200
  rescue Exception => e
    @response = {error: e.message}
    @status = 400
  ensure
    respond_with(@response, :status => @status, :location => nil)
  end

private

  def incorrect_params?
    params[:login].nil? or params[:login] == '' or
    params[:password].nil? or params[:password] == ''
  end

end
