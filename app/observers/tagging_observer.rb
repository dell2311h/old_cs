class TaggingObserver < ActiveRecord::Observer
  observe :tagging
  def after_create(tagging)
    tag = tagging.tag.name
    place = Place.find_by_name tag
    event = Event.find_by_name tag

    if place
      FeedItem.create(:action      => "tagging",
                      :user_id     => tagging.user_id,
                      :entity    => place,
                      :context_type => "Video",
                      :context_id => tagging.comment.video_id);
    end

    if event
      FeedItem.create(:action      => "tagging",
                      :user_id     => tagging.user_id,
                      :entity    => event,
                      :context_type => "Video",
                      :context_id => tagging.comment.video_id);
    end

  end
end
