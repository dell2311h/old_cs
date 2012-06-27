require 'spec_helper'

describe UserNotification do

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :feed_item }
  end

  describe 'validations' do
    it { should validate_presence_of(:creation_date) }
   # it { should validate_numericality_of(:user_id) }
   # it { should validate_numericality_of(:feed_item_id) }
    
  end

  describe "#create_by_feed_item" do
    it "should create user_notification_by feed_item " do
      feed_item = Factory.create :comment_video_feed
      notification = UserNotification.create_by_feed_item feed_item
      notification.feed_item.should be_eql(feed_item)
      notification.user_id.should be_eql(feed_item.user_id)
    end
  end

  describe "#process_notifications" do
    it "should proccess feed item for notifications" do
      feed_item = FeedItem.new
      user = User.new
      feed_item.should_receive(:user).and_return(user)
      user.should_receive(:increment_new_notifications_count)
      EmailNotification.should_receive(:process_email_notification).with(feed_item)
      ApnNotification.should_receive(:deliver).with(feed_item)
      EmailNotification.process_notifications(feed_item)
    end
  end
end
