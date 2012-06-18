class LikeObserver < ActiveRecord::Observer

  def after_create(model)
    FeedItem.create_for_like(model)
  end

end

