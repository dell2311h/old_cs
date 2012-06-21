class CommentObserver < ActiveRecord::Observer

  def after_create(comment)
    FeedItem.create_for_comment(comment)
  end

end

