require 'spec_helper'

describe Api::PlacesController do
    
  describe 'GET index' do
  
    before :each do
      @places = Place # Start of chain    
      @result_array = []
    end  

    context "when some places are available" do
    
      before :each do
        @places.stub!(:near).and_return(@places)
        @places.stub!(:with_name_like).and_return(@places)
        @places.stub!(:paginate).and_return(@result_array)
        @places.stub!(:count => 2)
      end
      
      it 'should get list of ALL places' do
        params = {}
       
        @places.should_not_receive(:near)
        @places.should_not_receive(:with_name_like)
        @places.should_receive(:count).and_return(2)
        @places.should_receive(:paginate).with(:page => params[:page], :per_page => Settings.paggination.per_page).and_return(@result_array)
               
        get :index, :format => :json
        response.should be_ok
      end

      it "should get list of places with name matches" do
        params = { place_name: "Test Name" }       
        @places.should_receive(:with_name_like).with(params[:place_name]).and_return(@places)
        @places.should_receive(:count).and_return(2)
        @places.should_receive(:paginate).with(:page => params[:page], :per_page => Settings.paggination.per_page).and_return(@result_array)
        
        get :index, place_name: "Test Name" , :format => :json
        response.should be_ok
      end

      describe "retrive list of nearby places" do
        context 'with valid params' do
          it "should be ok" do
            lat = Faker::Geolocation.lat
            lng = Faker::Geolocation.lng
            params = { nearby: true, latitude: lat, longitude: lng }
            @places.should_not_receive(:with_name_like)
            @places.should_receive(:near).with([params[:latitude].to_s, params[:longitude].to_s], Settings.search.radius, :order => :distance).and_return(@places)
            @places.should_receive(:count).and_return(2)
            @places.should_receive(:paginate).with(:page => params[:page], :per_page => Settings.paggination.per_page).and_return(@result_array)
            
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

    context "when no any places are not available" do
    
      before :each do
        @places.stub!(:count => 0)
      end
      
      it 'should respond with not_found HTTP status' do
        get :index, :format => :json
        response.should be_not_found
      end
      
    end 
  end  
end
