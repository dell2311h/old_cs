require 'spec_helper'

describe Api::EventsController do

  
  describe "lists" do

    before(:each) do
      @events = []
      5.times do
        @events << Factory(:event).attributes
      end
    end

    describe "get list of ALL events" do
      expected = {:result => {@events}, :success => true, :description => "Events list."}.to_json
      get :index
      response.body.should == expected
    end
    
    describe "get list of TOP events" do
      expected = {:result => {@events}, :success => true, :description => "Top Events list."}.to_json
      get :top
      response.body.should == expected
    end
    
  end  

end
