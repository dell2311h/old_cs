require 'spec_helper'

describe Performer do

  describe "validations" do
    it { should respond_to(:name) }
    it { should respond_to(:picture) }
  end

  describe "associations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should have_many(:relationships).class_name("Relationship").dependent(:destroy) }
    it { should have_many(:followers).through(:relationships) }
  end

  describe "#search" do
    before :all do
      2.times { Factory.create :performer }
      @performer = Performer.last
    end

    it "should include performer if name mathces" do
      performers = Performer.search({ :performer_name => @performer.name })
      performers.count.should be > 0
      performers.should include(@performer)
    end

    it "should include performer if name partial mathces" do
      performers = Performer.search({ :performer_name => @performer.name[1, (@performer.name.length - 2)] })
      performers.count.should be > 0
      performers.should include(@performer)
    end

    it "should not include performer if name doesn't match" do
      random_string = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
      Performer.search({ :performer_name => @performer.name + random_string }).count.should eq 0
    end
  end

  describe "relationships" do

    before :each do
      FeedItem.stub!(:create_for_follow)
      Relationship.stub!(:accure_achievement_points)
    end

    describe "counters" do

      before :all do
        @user = Factory.create(:user)
        @performer = Factory.create(:performer)
      end

      describe ".with_followers_count" do

        context "when performer doesn't have any followers" do
          it "should have followers_count attribute with 0 value" do
            attributes = Performer.with_followers_count.find(@performer.id).attributes
            attributes["followers_count"].should == 0
          end
        end

        context "when event has followers" do
          it "should have followers_count attribute with value equal to 1" do
            @user.follow(@performer)
            attributes = Performer.with_followers_count.find(@performer.id).attributes
            attributes["followers_count"].should == 1
          end
        end

      end

     describe ".with_relationships_counters" do
       it "should return result that have 'followers_count' attribute" do
         Performer.with_relationships_counters.first.attributes.should include("followers_count")
       end
     end

    end

  end

end

