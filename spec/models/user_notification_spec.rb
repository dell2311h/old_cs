require 'spec_helper'

describe UserNotification do

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :feed_item }
  end

  describe "#process_notifications" do
    it "should proccess feed item for notifications" do
      feed_item = "feed_item"
      user = "user"
      message = ""
      UserNotification.should_receive(:find_feed_owner).with(feed_item).and_return(user)
      user.should_receive(:increment_new_notifications_count)
      UserNotification.should_receive(:format_message).with(feed_item).and_return(message)
      UserNotification.should_receive(:process_email_notification).with(user, feed_item)
      ApnNotification.should_receive(:store).with(message, user)
      UserNotification.process_notifications(feed_item)
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
      UserNotification.should_receive(:find_undelivered).and_return(notifications)
      grouped_notifications = notifications.group_by(& :user_id)
      grouped_notifications.each {|user_id, email_notifications| UserNotification.should_receive(:deliver_multiply).with(email_notifications)}
      notifications.should_receive(:group_by).and_return(grouped_notifications)
  
      UserNotification.deliver_undelivered
    end
  end

  describe "#create_by_feed_item" do
    it "should create user_notification_by feed_item " do
      feed_item = Factory.create :comment_video_feed
      user = feed_item.user
      notification = UserNotification.create_by_feed_item feed_item, user
      notification.feed_item.should be_eql(feed_item)
      #notification.user_id.should be_eql(feed_item.user_id, user)
    end
  end

  describe "#deliver" do
    it "should deliver email notification" do
      notification = UserNotification.new
      notification_text = ""
      UserNotification.should_receive(:format_message).and_return(notification_text)
      user = User.new
      user.email = "email@gmail.com"
      notification.should_receive(:user).and_return(user)
      mail = "mail to deliver"
      NotificationMailer.should_receive(:send_single_notification).with(user.email, notification_text).and_return(mail)
      mail.should_receive(:deliver)
      notification.send(:deliver)
    end
  end

  describe "#format_multiply_notifications" do
    it "should format notifications propperly" do
      notifications = []
      2.times do
        user = Factory.create :user, :email_notification_status => "week"
        feed = Factory.create :comment_video_feed, :user => user
        notification =  Factory.create :user_notification, :user => user, :feed_item => feed
        notifications << notification
        UserNotification.should_receive(:format_message).any_number_of_times
      end
  
      result = UserNotification.send(:format_multiply_notifications, notifications)
      result[:email].should be_eql(notifications.first.user.email)
      result[:texts].count.should be_eql 2
    end
  end

  describe "#deliver" do
    it "should deliver email notification" do
      notification = UserNotification.new
      notification_text = ""
      UserNotification.should_receive(:format_message).and_return(notification_text)
      user = User.new
      user.email = "email@gmail.com"
      notification.should_receive(:user).and_return(user)
      mail = "mail to deliver"
      NotificationMailer.should_receive(:send_single_notification).with(user.email, notification_text).and_return(mail)
      mail.should_receive(:deliver)
      notification.send(:deliver)
    end
  end

  describe "#destroy_delivered" do
    def create_notification
      notification = Factory.create(:user_notification)
      @ids << notification.id
      @notifications << notification
    end
    it "should destroy array of notifications" do
      @notifications = []
      @ids = []
      2.times { create_notification }

      UserNotification.destroy_delivered @notifications
      result = UserNotification.where :id => @ids

      result.should be_empty
    end
  end

  describe "#find_undelivered" do
    it "should find undelivered notifications that should be delivered" do
      user = Factory.create :user, :email_notification_status => "day"
      feed_item = Factory.create :comment_video_feed, :user => user
      should_be_delivered_notification = Factory.create :user_notification,
                                                        :creation_date => Time.now - 2.day,
                                                        :user => user,
                                                        :feed_item => feed_item
      should_not_be_delivered_notification = Factory.create :user_notification,
                                                            :creation_date => Time.now,
                                                            :user => user,
                                                            :feed_item => feed_item
      undelivered_notifications = UserNotification.find_undelivered
      undelivered_notifications.should include(should_be_delivered_notification)
      undelivered_notifications.should_not include(should_not_be_delivered_notification)
    end
    
  end

end
