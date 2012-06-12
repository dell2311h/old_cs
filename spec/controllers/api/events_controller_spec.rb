require 'spec_helper'

describe Api::EventsController do

  describe 'GET index' do

    before :each do
      @events = Event # Start of chain
      @result_array = []
    end

    context "when some events are available" do

      before :each do
        @events.stub!(:order_by_video_count).and_return(@events)
        @events.stub!(:nearby).and_return(@events)
        @events.stub_chain(:paginate, :with_videos_comments_count).and_return(@result_array)
        @events.stub!(:count => 2)
      end

      it 'should get list of ALL events' do
        params = {}

        @events.should_not_receive(:order_by_video_count)
        @events.should_not_receive(:nearby)
        @events.should_receive(:count).and_return(2)
        @events.should_receive(:paginate).and_return(@events)
        @events.should_receive(:with_videos_comments_count).and_return(@result_array)
        get :index, :format => :json
        response.should be_ok
      end

      it "should get list of TOP events (ordered by video count)" do
        params = {}
        @events.should_receive(:order_by_video_count).and_return(@events)
        @events.should_not_receive(:nearby)
        @events.should_receive(:count).and_return(2)
        @events.should_receive(:paginate).and_return(@events)
        @events.should_receive(:with_videos_comments_count).and_return(@result_array)

        get :index, top: "true", :format => :json
        response.should be_ok
      end

      describe "retrive list of nearby events" do
        context 'with valid params' do
          it "should be ok" do
            lat = Faker::Geolocation.lat
            lng = Faker::Geolocation.lng
            params = { nearby: true, latitude: lat, longitude: lng }
            @events.should_not_receive(:order_by_video_count)
            @events.should_receive(:nearby).with([params[:latitude].to_s, params[:longitude].to_s], Settings.search.radius).and_return(@events)
            @events.should_receive(:count).and_return(2)
            @events.should_receive(:paginate).and_return(@events)
            @events.should_receive(:with_videos_comments_count).and_return(@result_array)

            get :index, nearby: true, latitude: lat, longitude: lng, :format => :json
            response.should be_ok
          end
        end

        context 'with invalid params' do
          it "should be bad_request" do
            get :index, :nearby => true, :format => :json
            response.should be_bad_request
          end
        end
      end
    end

    context "when no any events are not available" do

      before :each do
        @events.stub!(:count => 0)
      end

      it 'should respond with not_found HTTP status' do
        get :index, :format => :json
        response.should be_not_found
      end
    end



  end

end
