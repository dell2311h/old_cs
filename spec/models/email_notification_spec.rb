require 'spec_helper'

describe EmailNotification do

  describe "find_undelivered" do
    it "should find undelivered notifications that should be delivered" do
      user = Factory.create :user, :email_notification_status => "day"
      feed_item = Factory.create :comment_video_feed, :user => user
      should_be_delivered_notification = Factory.create :email_notification,
                                                        :creation_date => Time.now - 2.day,
                                                        :user => user,
                                                        :feed_item => feed_item
      should_not_be_delivered_notification = Factory.create :email_notification,
                                                            :creation_date => Time.now,
                                                            :user => user,
                                                            :feed_item => feed_item

      EmailNotification.find_undelivered.should include(should_be_delivered_notification)
      EmailNotification.find_undelivered.should_not include(should_not_be_delivered_notification)
    end
    
  end

  describe "#destroy_delivered" do
    def create_notification
      notification = Factory.create(:email_notification)
      @ids << notification.id
      @notifications << notification
    end
    it "should destroy array of notifications" do
      @notifications = []
      @ids = []
      2.times { create_notification }
  
      EmailNotification.destroy_delivered @notifications
      result = EmailNotification.where :id => @ids
  
      result.should be_empty
    end
  end

  describe "#deliver_multiply" do
    it "should deliver notifications" do
      notifications = []
      notification_params = {:email => "", :texts => [], :period => Time.now}
      EmailNotification.should_receive(:format_multiply_notifications).with(notifications).and_return(notification_params)
      email = "email to deliver"
      NotificationMailer.should_receive(:send_multiply_notifications).with(notification_params[:email],
                                                                           notification_params[:texts],
                                                                           notification_params[:period]).and_return(email)
  
      EmailNotification.should_receive(:destroy_delivered).with(notifications)
      email.should_receive(:deliver)
      EmailNotification.deliver_multiply notifications
    end
  end

  describe "#format_multiply_notifications" do
    it "should format notifications propperly" do
      notifications = []
      2.times do
        notification =  Factory.create(:email_notification)
        notifications << notification
        notification.should_receive(:format_message)
      end
  
      result = EmailNotification.format_multiply_notifications notifications
      result[:email].should be_eql(notifications.first.user.email)
      result[:texts].count.should be_eql 2
    end
  end

  describe "#deliver" do
    it "should deliver email notification" do
      email_notification = EmailNotification.new
      notification_text = ""
      email_notification.should_receive(:format_message).and_return(notification_text)
      user = User.new
      user.email = "email@gmail.com"
      email_notification.should_receive(:user).and_return(user)
      mail = "mail to deliver"
      NotificationMailer.should_receive(:send_single_notification).with(user.email, notification_text).and_return(mail)
      mail.should_receive(:deliver)
      email_notification.deliver
    end
  end

  describe "#deliver_undelivered" do
    it "should deliver undelivered notification" do
      notifications = []
      2.times do |index|
        notification = UserNotification.new
        notification.user_id = index
        notifications << notification
      end
      EmailNotification.should_receive(:find_undelivered).and_return(notifications)
      grouped_notifications = notifications.group_by(& :user_id)
      grouped_notifications.each {|user_id, email_notifications| EmailNotification.should_receive(:deliver_multiply).with(email_notifications)}
      notifications.should_receive(:group_by).and_return(grouped_notifications)
  
      EmailNotification.deliver_undelivered
    end
  end

  describe "#process_email_notification" do
    context "deliver immediately" do
      it "should deliver email notification" do
        user = Factory.create :user, :email_notification_status => "immediate"
        feed_item = Factory.create :comment_video_feed, :user => user
        email_notification = Factory.create :email_notification, :user => user, :feed_item => feed_item
        email_notification.should_receive(:deliver)
        EmailNotification.should_receive(:create_by_feed_item).with(feed_item).and_return(email_notification)
        EmailNotification.process_email_notification(feed_item)
      end
    end

    context "deviver later" do
      it "should store notification to deliver later" do
        user = Factory.create :user, :email_notification_status => "day"
        feed_item = Factory.create :comment_video_feed, :user => user
        email_notification = Factory.create :email_notification, :user => user, :feed_item => feed_item
        email_notification.should_receive(:save)
        EmailNotification.should_receive(:create_by_feed_item).with(feed_item).and_return(email_notification)
        EmailNotification.process_email_notification(feed_item)
      end
    end

    context 'should not deliver notifications' do
      it "should not prpcess notification for user with turned off email notifications" do
        user = Factory.create :user, :email_notification_status => "none"
        feed_item = Factory.create :comment_video_feed, :user => user
        email_notification = Factory.create :email_notification, :user => user, :feed_item => feed_item
        EmailNotification.should_not_receive(:create_by_feed_item)
        EmailNotification.process_email_notification(feed_item)
      end
    end
  end

end
