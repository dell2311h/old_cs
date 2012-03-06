require 'spec_helper'

describe Api::UsersController do

  describe "#create" do

    it "should responds with JSON" do
      user = stub_model(User,:save=>true)
      User.stub(:new).with({'these' => 'params'}) { user }
      post :create, :user => {'these' => 'params'}, :format => :json
      response.body.should eq user.to_json
    end

    context 'with correct request params' do
      before :all do
        @json = {:name => "User", :email => "user@gmail.com", :password => "password", :username => "user111", :age => 33}
      end
      it "should return object of the newly created user" do
        User.delete_all
        post :create, :format => :json, :user => @json
        response.code.should == '201'
        result = JSON.parse(response.body)
        result['id'].should_not be_nil
        result['name'].should eq 'User'
      end
    end

    context 'with incorrect request params' do
      before :all do
        @json = {:name => "Us", :email => "usergmail.com", :password => "****", :login => "us", :age => 99}
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

    it "should responds with JSON" do
      user = stub_model(User)
      User.stub(:find).with('1') { user }
      get :show, :id => '1', :format => :json
      response.body.should eq user.to_json
    end

    context 'with correct request params' do
      it "should return user" do
        user = stub_model(User)
        User.stub(:find).with('1') { user }
        get :show, :id => '1', :format => :json
        response.body.should eq user.to_json
      end
    end

    context 'with incorrect request params' do
      it "should return an hash with error message" do
        User.delete_all
        get :show, :format => :json, :id => '1'
        response.code.should == '404'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end
  end

  describe "#update" do

    it "should responds with JSON" do
      user = stub_model(User)
      User.stub(:find).with('1') { user }
      User.stub(:update_attributes).with({'name' => 'NewName'}) { user }
      post :update, :id => '1', :user => {'name' => 'NewName'}, :format => :json
      response.body.should eq user.to_json
    end

    context 'with correct request params' do
      before :all do
        @user = Factory.create(:user)
        @json = {:name => "UserUpdated"}
      end
      it "should return object with updated attributes" do
        put :update, :format => :json, :id => @user.id, :user => @json
        response.code.should == '200'
        result = JSON.parse(response.body)
        result['name'].should eq 'UserUpdated'
      end
    end

    context 'with incorrect request params' do
      before :all do
        User.delete_all
        @json = {:user => {:login => "UserUpdated"}}
      end
      it "should return hash with error message" do
        post :create, :format => :json, :id => 1, :user => @json
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end

  end
end
