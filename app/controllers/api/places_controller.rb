require "foursquare_lib"
class Api::PlacesController < Api::BaseController

  def remote
    search_params = {}
    raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
    check_coordinates_format
    search_params[:latitude]  = params[:latitude]
    search_params[:longitude] = params[:longitude]
    search_params[:radius]    = SEARCH_RADIUS

    if params[:place_name]
      search_params[:query] = params[:place_name]
    end

     if search_params.empty?
      respond_with [], :status => :not_found
      return
    end

    places = ForsquareLib::Api.find_places search_params

    if places.empty?
      respond_with [], :status => :not_found
      return
    end

    respond_with places, :status => :ok, :location => nil
  end

  def index
    @places = Place

    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      check_coordinates_format
      @places = @places.near [params[:latitude], params[:longitude]], SEARCH_RADIUS, :order => :distance
    end

    if query_str = params[:place_name] || params[:q]
      @places = @places.with_name_like query_str
    end

    if @places.count > 0
      @places = @places.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
    else
      respond_with [], :status => :not_found
    end

  end
  
  def create
    @place = @current_user.places.create! params[:place]
    respond_with @place, :status => :created, :location => nil
  end

end

