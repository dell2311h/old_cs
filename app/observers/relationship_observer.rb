class RelationshipObserver < ActiveRecord::Observer

  def after_create(model)
    FeedItem.create!(:action => 'follow', :user => model.follower, :entity => model.followable)
  end

end

