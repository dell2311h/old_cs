require 'spec_helper'

describe User do

  let(:user_one) { Factory.create :user }
  let(:user_two) { Factory.create :user }

  describe "validations" do

    subject { user_one }

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }

    describe "password" do
      subject { User.new }
      it { should validate_presence_of(:password) }
    end

    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }

    it { should ensure_length_of(:username).
                  is_at_least(3).
                  is_at_most(255) }

    it { should ensure_length_of(:password).
                  is_at_least(6).
                  is_at_most(255) }

    it { should allow_value("email@gmail.com").for(:email) }
    it { should_not allow_value("email.gmail.com1").for(:email) }
    it { should_not allow_value(".gmail.com1").for(:email) }
    it { should_not allow_value("email.sddsds.").for(:email) }

  end

  describe "associations" do

    subject { user_one }

    it { should have_many(:comments) }
    it { should have_many(:videos) }
    it { should have_many(:places) }
    it { should have_many(:events) }
    it { should have_many(:relationships).dependent(:destroy) }
    it { should have_many(:reverse_relationships).class_name("Relationship").conditions("followable_type = 'User'").dependent(:destroy) }
    it { should have_many(:followers).through(:reverse_relationships) }

    it { should have_many(:followed_users).through(:relationships) }
    it { should have_many(:followed_events).through(:relationships) }
    it { should have_many(:followed_places).through(:relationships) }
    it { should have_many(:followed_performers).through(:relationships) }

  end

  describe "relationships" do

    before :each do
      FeedItem.stub!(:create_for_follow)
      Relationship.stub!(:accure_achievement_points)
    end

    describe "#follow" do
      it "should create an relationship" do
        relationship = user_one.follow(user_two)
        relationship.follower.should == user_one
        relationship.followable.should == user_two
      end
    end

    describe "#unfollow" do
      it "should delete an relationship" do
        user_one.follow(user_two)
        relationship = user_one.unfollow(user_two)
        relationship.persisted?.should be false
      end
    end

    describe "#following?" do

      it "should be true if one user follows other" do
        user_one.follow(user_two)
        user_one.following?(user_two).should be true
      end

      it "should be false if one user doesn't follow other" do
        user_one.following?(user_two).should be false
      end

    end

    describe "counters" do

      before :all do
        @user_one = Factory.create(:user)
        @user_two = Factory.create(:user)
      end

      describe ".with_followers_count" do

        context "when user doesn't have any followers" do
          it "should have followers_count attribute with 0 value" do
            attributes = User.with_followers_count.find(@user_one.id).attributes
            attributes["followers_count"].should == 0
          end
        end

        context "when user has followers" do
          it "should have followers_count attribute with value equal to 1" do
            @user_two.follow(@user_one)
            attributes = User.with_followers_count.find(@user_one.id).attributes
            attributes["followers_count"].should == 1
          end
        end

      end

      describe ".with_followings_count" do

        context "when user doesn't have any followers" do
          it "should have followings_count attribute with 0 value" do
            attributes = User.with_followings_count.find(@user_one.id).attributes
            attributes["followings_count"].should == 0
          end
        end

        context "when user has followers" do
          it "should have followings_count attribute with value equal to 1" do
            @user_one.follow(@user_two)
            attributes = User.with_followings_count.find(@user_one.id).attributes
            attributes["followings_count"].should == 1
          end
        end

      end

     describe ".with_relationships_counters" do
       it "should return result that have 'followers_count', 'followings_count' attributes" do
         User.with_relationships_counters.first.attributes.should include("followers_count", "followings_count")
       end
     end

    end

  end

end

