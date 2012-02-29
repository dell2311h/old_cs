require 'spec_helper'

describe Api::EventsController do

  
  describe "lists" do

    before(:each) do
      3.times do
        Factory(:event)
      end
      @events = Event.all.map do |event|
        event.api_data
      end
    end

    it "should get list of ALL events" do
      get :index     
      response.code.should == '200'

      result = JSON.parse(response.body)
      result.should == {:result => @events, :success => true, :description => "Events list."}
    end
    
    it "should get list of TOP events" do
      get :top
      response.code.should == '200'
      
      result = JSON.parse(response.body)
      result.should == {:result => @events, :success => true, :description => "Top Events list."}
    end
    
  end  

end
