class Api::EventsController < Api::BaseController

  def index
    @events = Event

    if params[:top]
      @events = @events.order_by_video_count
    end

    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      @events = @events.nearby [params[:latitude], params[:longitude]], SEARCH_RADIUS
    end

    if @events.count > 0
      @events = @events.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
      respond_with @events, :status => :ok
    else
      respond_with [], :status => :not_found
    end

  end
  
  def create
    @event = @current_user.create_event! params[:event]
    respond_with @event, :status => :ok
  end


end

