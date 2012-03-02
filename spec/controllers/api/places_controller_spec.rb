require 'spec_helper'

describe Api::PlacesController do
  
  describe 'lists' do
  
    before(:each) do
      3.times do
        Factory(:place)
      end
      @places = Place.all.map do |place|
        place.api_data
      end
    end
  
    describe 'user can search place by name' do
      it 'should get list of places by names' do
        get :list_by_name 
        response.code.should == '200'
        result = JSON.parse(response.body)         
        result.should == {"result" => @places, "success" => true, "description" => "Search results."}
      end
    end

    describe 'user can search nearby place by coordinates' do
      it 'should get are near user\'s location' do
        get :nearby
        response.code.should == '200'
        result = JSON.parse(response.body)         
        result.should == {"result" => @places, "success" => true, "description" => "Nearby places list."}
      end
    end
    
  end
  
end
