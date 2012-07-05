class Api::PlacesController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index, :show, :remote]

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
      raise I18n.t('errors.parameters.coordinates_not_provided') unless params[:latitude] && params[:longitude]
      Custom::Validators.validate_coordinates_with_message(params[:latitude], params[:longitude], I18n.t('errors.parameters.invalid_coordinates_format'))
      @places = @places.near [params[:latitude], params[:longitude]], Settings.search.radius, :order => :distance
    end

    if query_str = params[:place_name] || params[:q]
      @places = @places.with_name_like query_str
    end

    if @places.count > 0
      @places = @places.paginate(:page => params[:page], :per_page => params[:per_page]).with_flag_followed_by(current_user).with_calculated_counters
    else
      render :status => :not_found, json: {}
    end

  end

  def show
    @place = Place.with_flag_followed_by(current_user).with_calculated_counters.find(params[:id])
  end

  def create
    @place = current_user.places.create! params[:place]
    respond_with @place, :status => :created, :location => nil
  end

end

