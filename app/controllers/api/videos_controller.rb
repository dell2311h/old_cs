class Api::VideosController < Api::BaseController

  before_filter :check_params, :only => :create 

  def create
    @video = Video.new(params[:video])
    @video.user_id = @current_user.id
    @video.event_id = @event.id
    @status = 400

    if @video.save
      @status = 201
    else
      @video = {error: @video.errors}
    end

    rescue Exception => e
      @status = 400
      @video = {error: e.message}
    ensure
    #respond_with({user: @video}, :status => @status, :location => nil)
      render :json => @video, :status => @status
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
      respond_with [], :status => :not_found
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
  
private

  def check_params
    @current_user = User.first
    raise "Invalid params" if params[:event_id].nil?
    @event = Event.find params[:event_id]
    raise "Invalid params" if @event.nil?
    rescue Exception => e
      render :json => {error: e.message}, :status => 400
   end

end
