class Api::UsersController < Api::BaseController

  skip_before_filter :auth_check, :only => [:create]

  def create
    @user = User.new params[:user]
    @user.authentications.build(params[:oauth]) if params[:oauth]
    @user.save!
    @token = @user.authentication_token
    render status: :created, action: :show, locals: { token: @token }
  end

  def show
    @user = User.find(params[:id])
    @status = 200
  rescue Exception => e
    @status = 404
    @user = {error: e.message}
  ensure
    respond_with(@user, :status => @status, :location => nil)
  end

  def update
    @user = User.find(params[:id])
    @status = 400
    @status = 200 if @user.update_attributes(params[:user])
  rescue Exception => e
    @status = 404
    @user = {error: e.message}
  ensure
    # respond_with(@user, :status => @status, :location => nil)
    # TODO: respond_with always return 204 No Content
    render :json => @user.to_json, :status => @status
  end

end
