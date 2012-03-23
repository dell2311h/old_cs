class Api::EventsController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index, :remote, :show]

  def remote
    search_params = {}
    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      check_coordinates_format
      search_params[:within] = SEARCH_RADIUS
      search_params[:latitude] = params[:latitude]
      search_params[:longitude] = params[:longitude]
    end

    if params[:date]
      search_params[:date] = params[:date]
    end

    if params[:event_name]
      search_params[:keywords] = params[:event_name]
    end

    unless params[:page].nil?
      params[:page_number] = params[:page]
      params[:page_size] = ITEMS_PER_PAGE
    end

    if search_params.empty?
      respond_with [], :status => :not_found
      return
    end

    events = EventfulLib::Api.find_events search_params

    if events.empty?
      respond_with [], :status => :not_found
      return
    end

    respond_with events, :status => :ok, :location => nil
  end

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

    if params[:date]
      @events = @events.around_date Date.parse(params[:date])
    end

    if query_str = params[:event_name] || params[:q]
      @events = @events.with_name_like query_str
    end

    if @events.count > 0
      @events = @events.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
    else
      render :status => :not_found, json: {}
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

