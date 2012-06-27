require 'spec_helper'

describe "Relationships" do

  before :all do
    @user = Factory.build(:user, :id => rand(100))
    @another_user  = Factory.build(:user, :id => rand(100))
    attrs = @another_user.attributes.merge('followed' => rand(2), 'followers_count' => rand(100), 'followings_count' => rand(100))
    @another_user.instance_variable_set(:@attributes, attrs)
  end

  let(:expected_hash) {
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

  describe "GET /api/me/followings.json" do
    it "returns list of current_user followings" do
      User.should_receive(:find_by_authentication_token).and_return(@user)
      users = double('users_relation')
      users_with_followed_flag = double('users_relation_with_followed_flag')
      @user.should_receive(:followed_with_type).with('users').and_return(users)
      users.should_receive(:with_flag_followed_by).with(@user).and_return(users_with_followed_flag)
      users_with_followed_flag.should_receive(:with_relationships_counters).and_return([@another_user])
      get "/api/me/followings.json", :type => 'users'
      response.status.should be(200)
      response.should render_template(:index)
      result = JSON.parse(response.body)
      result.should be_kind_of(Array)
      element = result[0]
      element.should include(expected_hash)
    end
  end

end

