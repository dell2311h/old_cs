require 'spec_helper'

describe Api::UserSessionsController do

  describe "#create" do

    before :each do
      @user = double("user")
      @user.stub(:email => "user@mail.com", :password => "password",
                 :authentication_token => "token")
      @authentication = double("authentication")
      @authentication.stub(:token => "token", :uid => "123123",
                           :provider => "facebook", :user => @user)

    end

    context 'with correct email and password' do
      before :each do
        User.stub(:find_by_email).and_return( @user )
        @user.stub(:valid_password?).and_return( true )
      end
      it "should return authentication token" do
        User.should_receive(:authorize_by).and_return(@user)
        post :create, :format => :json, :email => @user.email, :password => @user.password
        response.code.should == '200'
        result = JSON.parse(response.body)
        result['token'].should_not be_nil
      end
    end

    context "with correct provider, uid and token" do
      before :each do
        Authentication.stub(:find_by_provider_and_uid).and_return( @authentication )
      end
      it "should return authentication token" do
        post :create, :format => :json, :provider => @authentication.provider, :uid => @authentication.uid, :token => @authentication.token
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
        post :create, :format => :json, :provider => '', :uid => @authentication.uid, :token => @authentication.token
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
        post :create, :format => :json, :provider => @authentication.provider, :uid => '', :token => @authentication.token
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
        post :create, :format => :json, :provider => @authentication.provider, :uid => @authentication.uid, :token => ''
        response.code.should == '400'
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end
  end

end
