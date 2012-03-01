require 'spec_helper'

describe Place do
  
  before(:each) do
    @place = Factory(:place)
  end
  
  subject { @place }
  
  it { should respond_to(:name) }
  it { should respond_to(:latitude) }  
  it { should respond_to(:longitude) }
  it { should respond_to(:user_id) }  
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:latitude) }
  it { should validate_presence_of(:longitude) }
  it { should validate_presence_of(:user_id) }
  
  it { should respond_to :api_data }
  
  it "should return api data in appropriate format" do
    @place.api_data.keys.should ==  ["id", "name", "user_id", "latitude", "longitude"]
  end
  
end
