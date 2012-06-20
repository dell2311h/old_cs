class CommentObserver < ActiveRecord::Observer
  observe :comment

  def after_create(comment)
    create_mention_feeds_for comment
    create_video_comment_feeds_for comment
  end

  private

  def create_video_comment_feeds_for comment
    FeedItem.create(:action       => "comment_video",
                    :user_id      => comment.user_id,
                    :entity_type  => "Video",
                    :entity_id    => comment.video_id,
                    :context => comment.video.event
                    )
  end

  def create_mention_feeds_for comment
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

  def create_mention_feeds comment, feeded_items
    feeded_items.each do |feeded_item|
      FeedItem.create(:action       => "mention",
                      :user_id      => comment.user_id,
                      :entity       => feeded_item,
                      :context_type => "Video",
                      :context_id   => comment.video_id)
    end
  end

  def feed_users mention, comment
    users = User.where("UPPER(username) = ?", mention.upcase)
    create_mention_feeds comment, users
  end

  def feed_performers mention, comment
    performers = Performer.where("UPPER(name) = ?", mention.upcase)
    create_mention_feeds comment, performers
  end

end

