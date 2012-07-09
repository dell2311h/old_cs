class Api::UsersController < Api::BaseController

  skip_before_filter :auth_check, :only => [:create]

  def create
    oauth = params[:oauth]
    @user = User.find_by_email(params[:user][:email]) || User.new(params[:user])
    if @user.new_record?
      @user.authentications.build(oauth) if oauth
    else
      raise I18n.t('errors.parameters.wrong_password') unless @user.valid_password? params[:user][:password]
      @user.authentications.create(oauth) unless @user.authentications.find_by_provider_and_uid(oauth[:provider], oauth[:uid]) if oauth
    end

    @user.save!

    sign_in @user

    render status: :created, action: :show
  end

  def show
    @user = User.profile_details_by_id(me? ? current_user.id : params[:id], current_user)
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
    @users = User.search_by params, current_user
    if @users.count > 0
      @users = @users.paginate(:page => params[:page], :per_page => params[:per_page]).with_relationships_counters
    else
      render :status => :not_found, json: {}
    end
  end

  def provider_local_friends
    @users = current_user.remote_friends_on_crowdsync_for(params['provider'])
    @followed_users = User.find_followed_by(current_user)
    if @users.count < 1
      render :status => :not_found, json: {}
    end

    render status: :ok, :template => "api/users/index"
  end

  def provider_remote_friends
    @users = current_user.remote_friends_not_on_crowdsync_for params['provider']
    if @users.count < 1
      render :status => :not_found, json: {}
    end

  end
end

