require 'spec_helper'

describe Place do
  let(:place) { Factory.create :place }

  it { should respond_to(:name) }
  it { should respond_to(:latitude) }  
  it { should respond_to(:longitude) }
  it { should respond_to(:user_id) }  
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:latitude) }
  it { should validate_presence_of(:longitude) }
  it { should validate_presence_of(:user_id) }
  
  it { should have_many(:events) }
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:taggings).dependent(:destroy) }
  it { should have_many(:place_providers).dependent(:destroy) }
      
  describe "#with_name_like" do
    before :all do
      2.times { Factory.create :place }
    end

    it "should include place on full name match" do
      places = Place.with_name_like(place.name)
      places.count.should be > 0
      places.should include(place)
    end
    
    it "should include place if name mathces partially" do
      places = Place.with_name_like(place.name[1, (place.name.length - 2)])
      places.count.should be > 0
      places.should include(place)
    end
    
    it "should not include place if name doesn't match" do
      random_string = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
      Place.with_name_like(place.name + random_string).count.should eq(0)
    end
  end
end
