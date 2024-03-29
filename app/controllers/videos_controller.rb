class VideosController < ApplicationController

  before_filter :authenticate_user!


  def index
    @videos = Video.unscoped.for_user(current_user).order("created_at DESC").paginate(:page => params[:page])
  end

  def new
    @video = Video.new
    @events = Event.all
  end

  def create
    file = params[:video].delete(:clip)
    @video = Video.new(params[:video])
    @video.user = current_user
    @video.uuid = "uuid"
    @video.status = Video::STATUS_NEW
    if @video.attach_clip(file)
      @video.create_encoding_media
      respond_to do |format|
        format.html {
            render :json => [@video.to_jq_upload].to_json,
            :content_type => 'text/html',
            :layout => false
        }
        format.json {
            render :json => [@video.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => @video.errors}], :status => 304
    end

  end

  def update
    @video = Video.unscoped {
      Video.for_user(current_user).find(params[:id]).update_attributes!(params[:video])
    }

    redirect_to videos_path, :notice => "Thumbnail for video ID #{params[:id]} was successfully set up."
  end

  def destroy
    @video = Video.find params[:id]
    @video.destroy if @video.user == current_user
    respond_to do |format|
      format.html { redirect_to videos_path, notice: 'Video was successfully deleted.' }
      format.json { render :json => true }
    end
  end

end

