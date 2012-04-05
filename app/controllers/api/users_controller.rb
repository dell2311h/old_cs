class Api::UsersController < Api::BaseController

  skip_before_filter :auth_check, :only => [:create]

  def create
    oauth = params[:oauth]
    @user = User.find_by_email(params[:user][:email]) || User.new(params[:user])
    if @user.new_record?
      @user.authentications.build(oauth) if oauth
    else
      raise "Wrong password" unless @user.valid_password? params[:user][:password]
      @user.authentications.create(oauth) unless @user.authentications.find_by_provider_and_uid(oauth[:provider], oauth[:uid]) if oauth
    end

    @user.save!
    @token = @user.authentication_token
    render status: :created, action: :show
  end

  def show
    @user = me? ? current_user : User.find(params[:id])
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
