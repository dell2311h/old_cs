
class Api::EventsController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index, :remote, :show, :recommended, :playlist, :random_playlist]

  def remote
    @events = EventfulEvent.search params
    if @events[:events].empty?
      render :status => :not_found, json: []

      return
    end
  end

  def index
    @events = Event

    if params[:top]
      @events = @events.order_by_video_count
    end

    if params[:nearby]
      raise I18n.t('errors.parameters.coordinates_not_provided') unless params[:latitude] && params[:longitude]
      check_coordinates_format
      @events = @events.nearby [params[:latitude], params[:longitude]], Settings.search.radius
    end

    if params[:date]
      @events = @events.around_date Date.parse(params[:date])
    end

    if query_str = params[:event_name] || params[:q]
      @events = @events.with_name_like query_str
    end

    if (@events_count = @events.count) > 0
      @events = @events.paginate(:page => params[:page], :per_page => params[:per_page]).with_flag_followed_by(current_user).with_calculated_counters
    else
      render :status => :not_found, json: {}
    end

  end

  def show
    @event = Event.with_flag_followed_by(current_user).with_calculated_counters.find(params[:id])
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

  def playlist
    @event = Event.with_videos_comments_count.find params[:event_id]
    @master_track = @event.current_master_track
    render( :status => :not_found, :json =>  { :error => I18n.t('errors.models.event.master_track_not_reay') } ) if @master_track.nil?
    @timelines = @event.playlist
  end

  def random_playlist
    raise I18n.t 'errors.parameters.empty_count' if params[:count].nil?
    @event = Event.top_random_for params[:count]
    @master_track = @event.current_master_track
    @timelines = @event.playlist
    render status: :ok, :template => "api/events/playlist"
  end
end

