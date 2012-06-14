class TaggingObserver < ActiveRecord::Observer
  observe :tagging
  def after_create(tagging)
    tag = tagging.tag.name
    place = Place.find_by_name tag
    event = Event.find_by_name tag

    if place
      FeedItem.create(:action      => "tagging",
                      :user_id     => tagging.user_id,
                      :itemable    => place,
                      :contextable => tagging.comment);
    end

    if event
      FeedItem.create(:action      => "tagging",
                      :user_id     => tagging.user_id,
                      :itemable    => event,
                      :contextable => tagging.comment)
    end

  end
end
