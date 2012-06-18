class LikeObserver < ActiveRecord::Observer

  def after_create(model)
    FeedItem.create!(:action => 'like_video', :user => model.user, :entity => model.video, :context => model.video.event)
  end

end

