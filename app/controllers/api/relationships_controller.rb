class Api::RelationshipsController < Api::BaseController

  before_filter :find_user, :only => [:create, :destroy]

  def create
    @user = User.find params[:user_id]
    current_user.follow!(@user)
    render status: :created, json: {}
  end

  def destroy
    @user = User.find params[:user_id]
    current_user.unfollow!(@user)
    render status: :accepted, json: {}
  end


  private
    def find_user
      @user = User.find params[:user_id]
    end

end

