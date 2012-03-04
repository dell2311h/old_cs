require 'spec_helper'

describe Api::EventsController do

  before :each do
    @events = (1..2).collect { mock_model(Event) }
    Event.stub!(:order_by_video_count).and_return(@events)
    Event.stub!(:nearby).and_return(@events)
    Event.stub!(:paginate).and_return(@events)
  end

  describe 'GET index' do

    context "when some events are available" do
      it 'should get list of ALL events' do
        params = {}
        Event.stub!(:count => 2)
        Event.should_receive(:count).and_return(2)
        Event.should_receive(:paginate).with(:page => params[:page], :per_page => ITEMS_PER_PAGE).and_return(@events)
        get :index, :format => :json

        response.should be_ok
      end

      it "should get list of TOP events" do

      end

      it "should get list of nearby events" do

      end
    end

    context "when no any events are not available" do

    end



  end

end

