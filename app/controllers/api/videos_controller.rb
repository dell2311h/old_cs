class Api::VideosController < Api::BaseController
 
  skip_before_filter :auth_check, :only => [:index, :show]

  def create
    @event = Event.find params[:event_id]
    @video = @current_user.videos.build params[:video]
    @video.event = @event
    @video.save!
    render status: :created, action: :show
  end

  def index
    @videos = Video

    if params[:user_id]
      @videos = @videos.where(:user_id => params[:user_id])
    end

    if params[:event_id]
      @videos = @videos.where(:event_id => params[:event_id])
    end
    
    if params[:song_id]
      @song = Song.find params[:song_id]
      @videos = @song.videos
    end
    
    if params[:q]
      @videos = Video.with_name_like(params[:q])
    end

    if @videos.count > 0
      @videos = @videos.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
    else
      render :status => :not_found, json: {}
    end 
  end

  def show
    @video = Video.find(params[:id])
  end
  
  def update
    @video = Video.find(params[:id])
    @status = 400
    @status = 200 if @video.update_attributes(params[:video]) == true
    rescue Exception => e
     @status = 404
     @video = {error: e.message}
    ensure
       render :json => @video, :status => @status
  end
  
  def destroy
    @video = @current_user.videos.find params[:id]
    @video.destroy
    render status: :accepted, json: {}
  end
  
end
