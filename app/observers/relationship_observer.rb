class RelationshipObserver < ActiveRecord::Observer

  def after_create(model)
    FeedItem.create!(:action => 'follow', :user => model.follower, :itemable => model.followable)
  end

end

