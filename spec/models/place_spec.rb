require 'spec_helper'

describe Place do
  let(:place) { Factory.create :place }

  describe 'validations' do
    it { should respond_to(:name) }
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) }
    it { should respond_to(:user_id) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'associations' do
    it { should have_many(:events) }
    it { should belong_to(:user) }
    it { should have_many(:place_providers).dependent(:destroy) }
    it { should have_many(:relationships).class_name("Relationship").dependent(:destroy) }
    it { should have_many(:followers).through(:relationships) }
  end

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

  describe "relationships " do

    before :each do
      FeedItem.stub!(:create_for_follow)
      Relationship.stub!(:accure_achievement_points)
    end

    let(:user) { Factory.create :user }
    let(:place) { Factory.create :place }

    describe "counters" do

      before :all do
        @user = Factory.create(:user)
        @place = Factory.create(:place)
      end

      describe ".with_followers_count" do

        context "when place doesn't have any followers" do
          it "should have followers_count attribute with 0 value" do
            attributes = Place.with_followers_count.find(@place.id).attributes
            attributes["followers_count"].should == 0
          end
        end

        context "when event has followers" do
          it "should have followers_count attribute with value equal to 1" do
            @user.follow(@place)
            attributes = Place.with_followers_count.find(@place.id).attributes
            attributes["followers_count"].should == 1
          end
        end

      end

     describe ".with_relationships_counters" do
       it "should return result that have 'followers_count' attribute" do
         Place.with_relationships_counters.first.attributes.should include("followers_count")
       end
     end

    end

    describe ".with_flag_followed_by(user)" do
      context "when user donesn't follow place" do
        it "should have 'followed' attribute with 0 value" do
          Place.with_flag_followed_by(user).find(place.id).attributes["followed"].should == 0
        end
      end

      context "when user follows place" do
        it "should have 'followed' attribute with 1 value" do
          user.follow(place)
          Place.with_flag_followed_by(user).find(place.id).attributes["followed"].should == 1
        end
      end
    end

  end


end

