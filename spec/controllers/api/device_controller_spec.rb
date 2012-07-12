require 'spec_helper'

describe Api::DevicesController do
  before :each do
    @current_user = "current_user"
    controller.stub(:current_user => @current_user)
  end
  describe 'PUT create' do
    it "should register device" do
      device_token = "token" 
      device = "device"
      Device.should_receive(:register_device).with(@current_user, device_token).and_return(device)

      put :create, :format => :json, :device_token => device_token, :authentication_token => "token"
      response.should be_ok
    end
  end

  describe 'DELETE destroy' do
    it "should unregister user device" do
      Device.should_receive(:unregister_device).with(@current_user)
      delete :destroy, :format => :json, :authentication_token => "token"
      response.should be_ok
    end
  end

end
