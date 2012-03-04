class Api::UsersController < Api::BaseController

  def create
    @user = User.new(params[:user])
    @status = 400
    @status = 201 if @user.save
  rescue Exception => e
    @status = 400
    @user = {error: e.message}
  ensure
    respond_with({user: @user}, :status => @status, :location => nil)
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
    @status = 200 if @user.update_attributes(params[:user]) == true
  rescue Exception => e
    @status = 404
    @user = {error: e.message}
  ensure
    # respond_with(@user, :status => @status, :location => nil)
    # TODO: respond_with always return 204 No Content
    render :json => @user.to_json, :status => @status
  end

end
