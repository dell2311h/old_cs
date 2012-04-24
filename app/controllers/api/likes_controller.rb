class Api::LikesController < Api::BaseController

  before_filter :find_video, :only => [:create, :destroy]

  def index
    @user = me? ? current_user : User.find(params[:user_id])
    @videos = @user.liked_videos.with_calculated_counters.with_flag_liked_by_me(current_user)
    render status: :ok, :template => "api/videos/index"
  end

  def create
    current_user.like!(@video)
    render status: :ok, json: {}
  end

  def destroy
    current_user.unlike!(@video)
    render status: :ok, json: {}
  end

  private
    def find_video
      @video = Video.find params[:video_id]
    end
end
