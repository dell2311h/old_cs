require 'spec_helper'

describe Api::UsersController do

  describe "#create" do

    context 'with correct request params' do
      before :all do
        @json = {:username => "User", :email => "user@gmail.com", :password => "password"}
        @user = Factory.create :user
      end

      it "should return object of the newly created user" do
        post :create, :format => :json, :user => @json
        response.code.should == '201'
        result = JSON.parse(response.body)
        result['id'].should_not be_nil
        result['username'].should eq 'User'
      end

        context 'with information about user from social network' do
          before :all do
            @json = {:username => "User", :email => "user@gmail.com", :password => "password",
                     :authentications_attributes => [{:provider => "facebook", :uid => "33232",
                                                       :token => "567GFHJJHGghGJG76876VBVJHG"}]}
          end
          it "should create authentication for newly created user" do
            post :create, :format => :json, :user => @json
            response.code.should == '201'
            result = JSON.parse(response.body)
            result['id'].should_not be_nil
            User.find(result['id']).authentications.count.should eq 1
          end
        end
    end

    context 'with incorrect request params' do
      before :all do
        @json = {:username => "Us", :email => "usergmail.com", :password => "****", :login => "us"}
      end
      it "should return hash with error message" do
        post :create, :format => :json, :user => @json
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end

  end

  describe "#show" do
    before :all do
      @user = Factory.create :user
    end

    context 'with correct request params' do
      it "should return user" do
        get :show, :id => @user.id, :authentication_token => @user.authentication_token, :format => :json
        response.code.should == '200'
        response.should render_template("show")
        response.body.should match @user.username
      end
    end

    context 'with incorrect request params' do
      it "should return an json with error message" do
        get :show, :format => :json, :authentication_token => @user.authentication_token, :id => '0'
        response.code.should == '404'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end
  end

  describe "#update" do
    before :all do
      @user = Factory.create(:user)
      @json = {:username => "UserUpdated"}
    end

    context 'with correct request params' do
      it "should return object with updated attributes" do
        put :update, :format => :json, :id => @user.id, :user => @json, :authentication_token => @user.authentication_token
        response.code.should == '202'
        result = JSON.parse(response.body)
        result['username'].should eq 'UserUpdated'
      end
    end

    context 'with incorrect request params' do
      it "should return hash with error message" do
        post :create, :format => :json, :id => 1, :user => {:name => "WrongName"}, :authentication_token => @user.authentication_token
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end

  end
end
