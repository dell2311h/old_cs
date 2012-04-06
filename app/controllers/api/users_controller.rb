class Api::UsersController < Api::BaseController

  skip_before_filter :auth_check, :only => [:create, :index]

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
    @user = current_user
    @user.update_attributes!(params[:user])
    render status: :accepted, action: :show
  end

  def update_coordinates
    current_user.update_coordinates params
    render status: :accepted, json: {}
  end

  def index
    @users = User.find_users params
    if @users.count < 1
      render :status => :not_found, json: {}
      return
    end
  end

end

