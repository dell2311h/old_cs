class Api::FollowingsController < Api::BaseController

  before_filter :find_user, :only => [:create, :destroy]

  def create
    @user = User.find params[:user_id]
    current_user.follow!(@user)
    render status: :accepted
  end

  def destroy
    @user = User.find params[:user_id]
    current_user.unfollow!(@user)
    render status: :accepted
  end


  private
    def find_user
      @user = User.find params[:user_id]
    end

end

