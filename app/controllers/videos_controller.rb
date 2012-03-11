class VideosController < ApplicationController

  before_filter :authenticate_user!


  def index
    @videos = current_user.videos.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
    render :json => @videos.collect { |v| v.to_jq_upload }.to_json
  end

  def new
    @video = Video.new
    @events = Event.all
  end

  def create
    @video = Video.new(params[:video])
    @video.name = params[:video][:clip].original_filename
    @video.user = current_user
=begin
    respond_to do |format|
      if @video.save
        format.html { redirect_to videos_path, notice: 'Video was successfully created.' }
        format.json { render json: @video, status: :created, location: @video.clip.url }
      else
        format.html { render action: "new" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
=end
    if @video.save
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

  def destroy

    @video = Video.find params[:id]
    @video.destroy
=begin
    respond_to do |format|
      format.html { redirect_to videos_path, notice: 'Video was successfully deleted.' }
      format.json { head :ok }
    end
=end
    render :json => true
  end
end

