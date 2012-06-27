require 'spec_helper'

describe ApnNotification do
  describe "#send_to_device" do
    it "should add apn notification to delivery list" do
      apn_params = { :badge => 1, :alert => "", :sound => "" }
      device = "device"
      device.stub!(:id).and_return(1)
      notification = ApnNotification.new
      notification.should_receive(:format_apn_notification).and_return(apn_params)
      APN::Notification.should_receive(:create).with(({:badge  => apn_params[:badge],
                                                       :alert  => apn_params[:alert],
                                                       :sound  => apn_params[:sound],
                                                       :device_id => device.id}))
      notification.send_to_device device
    end
  end

  describe "#deliver" do
    it "should send notification to device if user has device_token" do
      device_token = "device token"
      feed_item = "feed item"
      notification = "notification"
      device = "device"
      feed_item.stub_chain(:user, :device_token).and_return(device_token)
      ApnNotification.should_receive(:find_device_by_token).with(device_token).and_return(device)
      ApnNotification.should_receive(:create_by_feed_item).with(feed_item).and_return(notification)
      notification.should_receive(:send_to_device).with(device)
      ApnNotification.deliver feed_item
    end
    it "should not send notification if user has no device_token" do
      device_token = nil
      feed_item = "feed item"
      notification = "notification"
      device = nil
      feed_item.stub_chain(:user, :device_token).and_return(device_token)
      ApnNotification.should_receive(:find_device_by_token).with(device_token).and_return(device)
      ApnNotification.should_not_receive(:create_by_feed_item)
      notification.should_not_receive(:send_to_device)
      ApnNotification.deliver feed_item
    end
  end

  describe "#format_apn_notification" do
    it "it should format apn notification param correctly" do
      user = Factory.create :user, :new_notifications_count => 56
      apn_notification = Factory.create :apn_notification, :user_id => user.id
      alert = apn_notification.format_message
      sound = Settings.notifications.apn.sound
      notifcation_params = apn_notification.send(:format_apn_notification)
      notifcation_params[:badge].should be_eql(user.new_notifications_count)
      notifcation_params[:alert].should be_eql(alert)
      notifcation_params[:sound].should be_eql(sound)
    end
  end
end