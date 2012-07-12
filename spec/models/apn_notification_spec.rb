require 'spec_helper'

describe ApnNotification do
  describe "#store" do
    it "should add apn notification to delivery list" do
      apn_params = { :badge => 1, :alert => "", :sound => "" }
      user = "user"
      message = ""
      user.stub!(:id).and_return(1)
      device = "device"
      device.stub!(:id).and_return(1)
      notification = ApnNotification.new
      ApnNotification.should_receive(:format_apn_notification).with(user, message).and_return(apn_params)
      ApnNotification.should_receive(:create).with(({:badge  => apn_params[:badge],
                                                       :alert  => apn_params[:alert],
                                                       :sound  => apn_params[:sound],
                                                       :user_id => user.id}))
      ApnNotification.store message, user
    end
  end

  describe "#deliver_undelivered" do
    it "should deliver undelivered notifications" do
      notifications = ""
      notifications.should_receive(:empty?).and_return(false)
      apn_notifications = [1,2,3]
      ApnNotification.should_receive(:find_undelivered).and_return(notifications)
      ApnNotification.should_receive(:create_apns_notifications).with(notifications).and_return(apn_notifications)
      ApnNotification.should_receive(:deliver)
      ApnNotification.should_receive(:update_sent).with(notifications)
      ApnNotification.deliver_undelivered
    end

    it "should not deliver undelivered notifications" do
      notifications = ""
      notifications.should_receive(:empty?).and_return(true)
      ApnNotification.should_receive(:find_undelivered).and_return(notifications)
      ApnNotification.should_not_receive(:create_apns_notifications)
      ApnNotification.should_not_receive(:deliver)
      ApnNotification.should_not_receive(:update_sent)
      ApnNotification.deliver_undelivered
    end
  end

  describe "#format_apn_notification" do
    it "it should format apn notification param correctly" do
      user = Factory.create :user, :new_notifications_count => 56
      message = ""
      sound = Settings.notifications.apn.sound
      notifcation_params = ApnNotification.send(:format_apn_notification, user, message)
      notifcation_params[:badge].should be_eql(user.new_notifications_count)
      notifcation_params[:alert].should be_eql(message)
      notifcation_params[:sound].should be_eql(sound)
    end
  end

  describe "#format_apns_notification" do
    it "should format apn notification class properly" do
      ApnNotification.new
      user = Factory.create :user
      device = Factory.create :device, :user => user
      notification = ApnNotification.new
      alert = "ALERT"
      badge = 1
      sound = Settings.notifications.apn.sound

      notification.user = user
      notification.alert = alert
      notification.badge = badge
      apns_notification = notification.format_apns_notification
      apns_notification.device_token.should be_eql(device.token)
      apns_notification.badge.should be_eql(badge)
      apns_notification.alert.should be_eql(alert)
      apns_notification.sound.should be_eql(sound)
    end
  end

  describe "#update_sent" do
    it "shuld update sent_at time" do
      notifications = []
      notification1 = Factory.create :apn_notification
      notification2 = Factory.create :apn_notification
      notifications << notification1
      notifications << notification2
      ApnNotification.update_sent(notifications)
      notification1.reload
      notification2.reload
      notification1.sent_at.should_not be_nil
      notification2.sent_at.should_not be_nil
    end
  end
  describe "#deliver" do
    it "should deviler apn" do
      apns = ""
      notifications = ""
      ApnNotification.should_receive(:configure_apns).and_return(apns)
      apns.should_receive(:send_notifications).with(notifications)
      ApnNotification.deliver notifications
    end
  end

  describe "#configure_apns" do
    it "should configure APNS properly" do
      pem = "#{Rails.root}/#{Settings.notifications.apn.pem_sertificate}"
      host = Settings.notifications.apn.gateway
      apns = ApnNotification.configure_apns
      apns.pem.should be_eql pem
      apns.host.should be_eql host
    end
  end
  
  describe "#create_apns_notifications" do
    it "should format apns notification class for each notification" do
      notification1 = "notification1"
      notification2 = "notification2"
      apn_notification1 = "apn_notification1"
      apn_notification2 = "apn_notification2"
      notification1.should_receive(:format_apns_notification).and_return(apn_notification1)
      notification2.should_receive(:format_apns_notification).and_return(apn_notification2)
      notifications = [ notification1, notification2 ]
      result = ApnNotification.create_apns_notifications notifications
      result.should include apn_notification1
      result.should include apn_notification2
    end
  end

  describe "#find_undelivered" do
    before :all do
      @devilered_notif = Factory.create :apn_notification, :sent_at => Time.now
      @undevilered_notif = Factory.create :apn_notification
      @result = ApnNotification.find_undelivered
    end
    
    it "should find undelivered apns" do
      @result.should include @undevilered_notif
    end
    it "should not find delivered apns" do
      @result.should_not include @devilered_notif
    end
    
  end

end