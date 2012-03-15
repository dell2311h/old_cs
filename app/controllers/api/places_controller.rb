class Api::PlacesController < Api::BaseController

  def index
    places = Place

    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      check_coordinates_format
      places = places.near [params[:latitude], params[:longitude]], SEARCH_RADIUS, :order => :distance
    end

    if params[:place_name]
      places = places.with_name_like params[:place_name]
    end

    if places.count > 0
      places = places.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
      respond_with places, :status => :ok
    else
      respond_with [], :status => :not_found
    end

  end
  
  def create
    @place = @current_user.places.create! params[:place]
    respond_with @place, :status => :created, :location => nil
  end

end

