class Api::EventsController < Api::BaseController
     
  def index
    events = api_hashes_array(Event.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE))
       
    render :status => "200", :json => {:success => true, :description => "Events list.", :result => events}
  end
  
  def top
    events = api_hashes_array(Event.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE))
    
    render :status => "200", :json => {:success => true, :description => "Top Events list.", :result => events}
  end
   
end
