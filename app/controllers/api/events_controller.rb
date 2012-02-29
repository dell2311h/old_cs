class Api::EventsController < Api::BaseController
     
  def index
    events = api_hashes_array(Event.all)
       
    render :status => "200", :json => {:success => true, :description => "Events list.", :result => events}
  end
  
  def top
    events = api_hashes_array(Event.all)
    
    render :status => "200", :json => {:success => true, :description => "Top Events list.", :result => events}
  end
   
end
