require 'spec_helper'

describe Api::UserSessionsController do

  describe "#create" do
    before :all do
      @user = Factory.create(:social_user)
      @auth = @user.authentications.first
    end
    context 'with correct email and password' do
      it "should return authentication token" do
        post :create, :format => :json, :email => @user.email, :password => @user.password
        response.code.should == '200'
        result = JSON.parse(response.body)
        result['token'].should_not be_nil
      end
    end

    context "with correct provider, uid and token" do
      it "should return authentication token" do
        post :create, :format => :json, :provider => @auth.provider, :uid => @auth.uid, :token => @auth.token
        response.code.should == '200'
        result = JSON.parse(response.body)
        result['token'].should_not be_nil
      end
    end

    context 'with empty email or password' do
      it "should return error" do
        post :create, :format => :json, :email => '', :password => @user.password
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
        post :create, :format => :json, :email => @user.email, :password => ''
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end

    context 'with empty provider, uid or token' do
      it "should return error" do
        post :create, :format => :json, :provider => '', :uid => @auth.uid, :token => @auth.token
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
        post :create, :format => :json, :provider => @auth.provider, :uid => '', :token => @auth.token
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
        post :create, :format => :json, :provider => @auth.provider, :uid => @auth.uid, :token => ''
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end
  end

end
