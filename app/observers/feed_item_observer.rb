class FeedItemObserver < ActiveRecord::Observer

  def after_create(feed_item)
    feed_item.send_notification
  end
end