require 'spec_helper'

describe Api::UserSessionsController do

  describe "#create" do
    before :all do
      @user = Factory.create(:user)
    end
    context 'with correct username and password' do
      it "should return authentication token" do
        post :create, :format => :json, :login => @user.username, :password => @user.password
        response.code.should == '200'
        result = JSON.parse(response.body)
        result['token'].should_not be_nil
      end
      context "if user's authentication token is empty" do
        before :all do
          @user.update_attribute(:authentication_token, nil)
        end
        it "should return authentication token" do
          post :create, :format => :json, :login => @user.username, :password => @user.password
          response.code.should == '200'
          result = JSON.parse(response.body)
          result['token'].should_not be_nil
        end
      end
    end

    context 'with correct email and password' do
      it "should return authentication token" do
        post :create, :format => :json, :login => @user.email, :password => @user.password
        response.code.should == '200'
        result = JSON.parse(response.body)
        result['token'].should_not be_nil
      end
    end

    context 'with empty login or password' do
      it "should return error" do
        post :create, :format => :json, :login => '', :password => @user.password
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
        post :create, :format => :json, :login => @user.email, :password => ''
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end
  end

end
