class TaggingObserver < ActiveRecord::Observer

  def after_create(tagging)
    FeedItem.create_for_tagging(tagging)
  end

end

