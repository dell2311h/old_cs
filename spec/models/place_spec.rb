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
  
  describe ".with_name_like" do
    it 'should give some search results' do
      searchable_name = @place.name
      Place.with_name_like(@place.name).count.should be > 0
      @place.update_attribute(:name, "blah#{@place.name}qwerty 123")
      p Place.with_name_like(@place.name)
      Place.with_name_like(@place.name).count.should be > 0
    end
    
    it 'should not give some search results' do
      Place.with_name_like("Ruby-Cola").count.should == 0
    end
  end
  
end
