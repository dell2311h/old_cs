require 'spec_helper'

describe "Relationships" do

  before :all do
    @user = Factory.build(:user, :id => rand(100))
    @another_user  = Factory.build(:user, :id => rand(100))
    attrs = @another_user.attributes.merge('followed' => rand(2), 'followers_count' => rand(100), 'followings_count' => rand(100))
    @another_user.instance_variable_set(:@attributes, attrs)
    relationships_hash = { 'followed' => rand(2), 'followers_count' => rand(100) }
    @place  = Factory.build(:place, :id => rand(100), :user_id => rand(100))
    place_attrs = @place.attributes.merge(relationships_hash)
    @place.instance_variable_set(:@attributes, place_attrs)
    @event = Factory.build :event, :place_id => rand(100), :user_id => rand(100), :id => rand(100)
    event_attrs = @event.attributes.merge(relationships_hash)
    @event.instance_variable_set(:@attributes, event_attrs)
    @performer = Factory.build :performer, :id => rand(100)
    performer_attrs = @performer.attributes.merge(relationships_hash)
    @performer.instance_variable_set(:@attributes, performer_attrs)
  end

  let(:expected_user_hash) {
    { "followers_count" => @another_user["followers_count"],
      "followings_count"=> @another_user["followings_count"],
      "followed" => (@another_user["followed"] == 1 ? true : false),
      "id" => @another_user.id,
      "username" => @another_user.username,
      "first_name" => @another_user.first_name,
      "last_name" => @another_user.last_name,
      "achievement_points_sum" => @another_user.achievement_points_sum,
      "avatar_url" => @another_user.avatar.thumb.url,
      "bio" => @another_user.bio
    }

  }

  let(:expected_place_hash) {
    { "followers_count" => @place["followers_count"],
      "followed" => (@place["followed"] == 1 ? true : false),
      "id" => @place.id,
      "name" => @place.name,
      "latitude" => @place.latitude,
      "longitude" => @place.longitude,
      "user_id" => @place.user_id,
      "address" => @place.address
    }

  }

  let(:expected_event_hash) {
    { "followers_count" => @event["followers_count"],
      "followed" => (@event["followed"] == 1 ? true : false),
      "id" => @event.id,
      "name" => @event.name,
      "date" => @event.date.to_s,
      "songs_count" => 0,
      "videos_count" => 0,
      "comments_count" => 0,
      "most_popular_video_id" => 1
    }

  }

  let(:expected_performer_hash) {
    { "followers_count" => @performer["followers_count"],
      "followed" => (@performer["followed"] == 1 ? true : false),
      "id" => @performer.id,
      "name" => @performer.name,
      "picture_url" => @performer.picture.url
    }

  }

  let(:relation) { double('relation') }
  let(:relation_with_followed_flag) { double('relation_with_followed_flag') }

  describe "GET /api/me/followings.json?type=users" do
    it "returns list of current_user followings by type 'users'" do
      check_for_entity(@another_user)
    end

  end

  describe "GET /api/me/followings.json?type=places" do
    it "returns list of current_user followings by type 'places'" do
      check_for_entity(@place)
    end
  end

  describe "GET /api/me/followings.json?type=events" do
    it "returns list of current_user followings by type 'events'" do
      @event.stub!(:place).and_return(@place)
      @event.stub!(:comments_count).and_return(0)
      video = double('video')
      video.stub!(:id).and_return(1)
      @event.stub!(:most_popular_video).and_return(video)
      check_for_entity(@event)
    end
  end

  describe "GET /api/me/followings.json?type=performers" do
    it "returns list of current_user followings by type 'performers'" do
      check_for_entity(@performer)
    end
  end

  describe "GET /api/users/:id/followings.json" do
    it "should call methods for proper user" do
      User.should_receive(:find_by_authentication_token).and_return(@user)
      User.should_receive(:find).with(@another_user.id.to_s).and_return(@another_user)
      @another_user.should_receive(:followed_with_type).and_return(relation)
      relation.should_receive(:with_flag_followed_by).with(@user).and_return(relation_with_followed_flag)
      relation_with_followed_flag.should_receive(:with_relationships_counters).and_return([@user])
      get "/api/users/#{@another_user.id}/followings.json"
      response.status.should be(200)
    end
  end

  describe "GET /api/users/:id/followers.json" do
    it "returns list of followers of user with :id" do
      User.should_receive(:find_by_authentication_token).and_return(@user)
      User.should_receive(:find).with(@another_user.id.to_s).and_return(@another_user)
      @another_user.should_receive(:followers).and_return(relation)
      relation.should_receive(:with_flag_followed_by).with(@user).and_return(relation_with_followed_flag)
      relation_with_followed_flag.should_receive(:with_relationships_counters).and_return([@another_user])
      get "/api/users/#{@another_user.id}/followers.json"
      response.should render_template(:index)
      result = JSON.parse(response.body)
      result.should be_kind_of(Array)
      element = result[0]
      element.should include(expected_user_hash)
      response.status.should be(200)
    end
  end

private
  def check_for_entity(entity)
    entity_class_name = entity.class.to_s.downcase
    plural_entity = entity_class_name.pluralize
    User.should_receive(:find_by_authentication_token).and_return(@user)
    @user.should_receive(:followed_with_type).with(plural_entity).and_return(relation)
    relation.should_receive(:with_flag_followed_by).with(@user).and_return(relation_with_followed_flag)
    relation_with_followed_flag.should_receive(:with_relationships_counters).and_return([entity])
    get "/api/me/followings.json", :type => plural_entity
    response.should render_template(:index)
    result = JSON.parse(response.body)
    result.should be_kind_of(Array)
    element = result[0]
    eval("element.should include(expected_#{entity_class_name}_hash)")
    response.status.should be(200)
  end

end

