class RelationshipObserver < ActiveRecord::Observer

  def after_create(model)
    FeedItem.create_for_follow(model)
  end

end

