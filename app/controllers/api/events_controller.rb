class Api::EventsController < Api::BaseController

  def index
    @events = Event

    if params[:top]
      @events = @events.order_by_video_count
    end

    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      check_coordinates_format
      @events = @events.nearby [params[:latitude], params[:longitude]], SEARCH_RADIUS
    end

    if params[:event_name]
      @events = @events.with_name_like params[:event_name]
    end

    if @events.count > 0
      @events = @events.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
    else
      respond_with [], :status => :not_found
    end

  end
  
  def show
    @event = Event.find params[:id]
  end
  
  def create
    if params[:place_id]
      @place = Place.find(params[:place_id]) 
      params[:event][:place_id] = @place.id
    end
    @event = @current_user.events.create! params[:event]
    respond_with @event, :status => :created, :location => nil
  end


end

