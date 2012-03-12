class Api::PlacesController < Api::BaseController

  def index
    places = Place

    if params[:nearby]
      raise "Coordinates are not provided" unless params[:latitude] && params[:longitude]
      raise "Coordinates are invalid" unless valid_number?(params[:latitude]) && valid_number?(params[:longitude])
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

end

