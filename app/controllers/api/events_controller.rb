class Api::EventsController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index, :remote, :show, :recommended]

  def remote
    search_params = {}
    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      check_coordinates_format
      search_params[:within] = Settings.search.radius
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
      search_params[:page_number] = params[:page]
      search_params[:page_size] = params[:per_page] || Settings.paggination.per_page
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
      @events = @events.nearby [params[:latitude], params[:longitude]], Settings.search.radius
    end

    if params[:date]
      @events = @events.around_date Date.parse(params[:date])
    end

    if query_str = params[:event_name] || params[:q]
      @events = @events.with_name_like query_str
    end

    if @events.count > 0
      @events = @events.paginate(:page => params[:page], :per_page => params[:per_page])
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
    @event = current_user.events.create! params[:event]
    respond_with @event, :status => :created, :location => nil
  end

  def recommended
    @events = []
    raise I18n.t 'errors.parameters.empty_videos' if params[:videos].nil?
    params[:videos].each do |video|
      events = Event
      if video[:date]
        events = events.around_date Date.parse(video[:date])
      end
      if video[:latitude] && video[:longitude]
        events = events.nearby [Float(video[:latitude]), Float(video[:longitude])], Settings.search.radius
      end
      @events += events if events.count > 0
    end
    if @events.count > 0
      @events.uniq!
      render status: :ok, :template => "api/events/index"
    else
      render :status => :not_found, json: {}
    end
  end
end
