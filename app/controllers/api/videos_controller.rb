class Api::VideosController < Api::BaseController

  before_filter :check_params, :only => :create

  def create
    @video = Video.new(params[:video])
    @video.user_id = @currentuser.id
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

    if params[:my]
      @videos = @videos.where(:user_id => @current_user.id)
    end

    if params[:event_id]
      @videos = @videos.where(:event_id => params[:event_id])
    end

    if @videos.count > 0
      @videos = @videos.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
      render status: :ok, json: {:videos => @videos, count: @videos.count}
    else
      respond_with [], :status => :not_found
    end 
  end

  def show
    @video = Video.find(params[:id])
    @status = 200
    rescue Exception => e
     @status = 404
     @video = {error: e.message}
    ensure
      #respond_with(@video, :status => @status, :location => nil)
      render :json => @video, :status => @status
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
  
private

  def check_params
    @currentuser = User.first
    raise "Invalid params" if params[:event_id].nil?
    @event = Event.find params[:event_id]
    raise "Invalid params" if @event.nil?
    rescue Exception => e
      render :json => {error: e.message}, :status => 400
   end

end
