require 'spec_helper'

describe "Relationships" do

  before :all do
    @user = Factory.create(:user)
    @another_user  = Factory.build(:user, :id => rand(100))
  end

  describe "GET /api/me/followings.json" do
    it "returns list of current_user followings" do
      User.should_receive(:find_by_authentication_token).and_return(@user)
      users = double('users_relation')
      users_with_followed_flag = double('users_relation_with_followed_flag')
      @user.should_receive(:followed_with_type).with('users').and_return(users)
      users.should_receive(:with_flag_followed_by).with(@user).and_return(users_with_followed_flag)
      attrs = @another_user.attributes.merge('followed' => rand(2), 'followers_count' => rand(100), 'followings_count' => rand(100))
      @another_user.stub!(:attributes).and_return(attrs)

      users_with_followed_flag.should_receive(:with_relationships_counters).and_return([@another_user])

      get "/api/me/followings.json", :type => 'users'
      response.status.should be(200)
      response.should render_template(:index)
    end
  end

=begin
  it "creates a Widget and redirects to the Widget's page" do
    get "/widgets/new"
    response.should render_template(:new)

    post "/widgets", :widget => {:name => "My Widget"}

    response.should redirect_to(assigns(:widget))
    follow_redirect!

    response.should render_template(:show)
    response.body.should include("Widget was successfully created.")
  end
=end

end

