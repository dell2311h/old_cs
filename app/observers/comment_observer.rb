class CommentObserver < ActiveRecord::Observer
  observe :comment
  def after_create(comment)
    mentions = comment.mentions
    if mentions
      FeedItem.transaction do
        begin
          mentions.each do |mention|
            feed_users  mention, comment
            feed_performers mention, comment
          end
        rescue ActiveRecord::StatementInvalid
        end
      end
    end
  end

  private

  def create_feeds comment, feeded_items
    feeded_items.each do |feeded_item|
      FeedItem.create(:action           => "mention",
                      :user_id          => comment.user_id,
                      :entity         => feeded_item,
                      :context_type => "Video",
                      :context_id   => comment.video_id)
    end
  end

  def feed_users mention, comment
    users = User.where("UPPER(username) = ?", mention.upcase)
    create_feeds comment, users
  end

  def feed_performers mention, comment
    performers = Performer.where("UPPER(name) = ?", mention.upcase)
    create_feeds comment, performers
  end

end