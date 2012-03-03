class Api::EventsController < Api::BaseController
     
  def index
    events = Event
    
    if params[:top]
      events = events.top
    end  
    
    if events.count > 0
      events = events.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
      respond_with events, :status => :ok   
    else  
      respond_with :status => :not_found
    end  
    
  end
 
   
end
