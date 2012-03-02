class Api::PlacesController < Api::BaseController

  def list_by_name
    places = api_hashes_array(Place.with_name_like(params[:place_name]).paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)) 
    render :status => "200", :json => {:success => true, :description => "Search results.", :result => places}
  end
  
  def nearby
    user_coordinates = [params[:latitude], params[:longitude]] 
    places = api_hashes_array(Place.near(user_coordinates, SEARCH_RADIUS, :order => :distance).paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)) 
    render :status => "200", :json => {:success => true, :description => "Nearby places list.", :result => places} 
  end
   
end
