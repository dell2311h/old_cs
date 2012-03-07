class VideosController < ApplicationController

  before_filter :authenticate_user!
  

  def index
    @videos = current_user.videos.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video])
    @video.user = current_user
    respond_to do |format|
      if @video.save
        format.html { redirect_to videos_path, notice: 'Video was successfully created.' }
        format.json { render json: @video, status: :created, location: @video.clip.url }
      else
        format.html { render action: "new" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy

    @video = Video.find params[:id]
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_path, notice: 'Video was successfully deleted.' }
      format.json { head :ok }
    end
  end
end
