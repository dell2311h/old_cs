class Api::PlacesController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index, :remote]

  def remote
    @places = FoursquarePlace.find params
    if @places.empty?
      respond_with [], :status => :not_found
      return
    end
  end

  def index
    @places = Place

    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      check_coordinates_format
      @places = @places.near [params[:latitude], params[:longitude]], Settings.search.radius, :order => :distance
    end

    if query_str = params[:place_name] || params[:q]
      @places = @places.with_name_like query_str
    end

    if @places.count > 0
      @places = @places.paginate(:page => params[:page], :per_page => Settings.paggination.per_page)
    else
      render :status => :not_found, json: {}
    end

  end

  def create
    @place = current_user.places.create! params[:place]
    respond_with @place, :status => :created, :location => nil
  end

end

