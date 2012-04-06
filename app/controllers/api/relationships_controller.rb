class Api::RelationshipsController < Api::BaseController

  before_filter :find_user, :only => [:create, :destroy]
  before_filter :set_source_user, :only => [:followings, :followers]

  def followings
    @users = @source_user.followings
    render status: set_status_by(@users), action: :index
  end

  def followers
    @users = @source_user.followers
    render status: set_status_by(@users), action: :index
  end


  def create
    current_user.follow!(@user)
    render status: :created, json: {}
  end

  def destroy
    current_user.unfollow!(@user)
    render status: :accepted, json: {}
  end


  private
    def find_user
      @user = User.find params[:user_id]
    end

    def set_source_user
      @source_user = me? ? current_user : find_user
    end

    def set_status_by collection
      collection.any? ? :ok : :not_found
    end

end

