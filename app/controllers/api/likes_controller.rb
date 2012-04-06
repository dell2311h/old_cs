class Api::LikesController < Api::BaseController

  before_filter :find_video, :only => [:create, :destroy]

  def index
  end

  def create
    current_user.like!(@video)
    render status: :created, json: {}
  end

  def destroy
    current_user.unlike!(@video)
    render status: :accepted, json: {}
  end

  private
    def find_video
      @video = Video.find params[:video_id]
    end
end
