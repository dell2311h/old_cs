class FeedItem < ActiveRecord::Base

  ALLOWED_ITEMABLES = ["User", "Video", "Song", "Comment", "Event", "Place", "Performer"]
  ALLOWED_CONTEXTABLES = ["Video", "Event", "Comment", "Authentication"]
  ALLOWED_ACTIONS = ["video_upload", "comment_video", "follow", "mention", "like_video", "join_crowdsync", "add_song"]

  belongs_to :user

  belongs_to :itemable, :polymorphic => true
  belongs_to :contextable, :polymorphic => true

  validates :user_id, :itemable_id, :itemable_type, :action, :presence => true
  validates :contextable_id, :contextable_type, :presence => true, :if => lambda { |f| f.contextable_type or f.contextable_type }
  validates :itemable_type, :inclusion => ALLOWED_ITEMABLES
  validates :action, :inclusion => ALLOWED_ACTIONS
  validates :contextable_type, :inclusion => ALLOWED_CONTEXTABLES, :if => lambda { |f| f.contextable_type }

  def message_for_feed(feed_type)
    raise "Not allowed feed type" unless [:user, :news, :notification].include?(feed_type)
    I18n.t "feed.#{feed_type}.#{self.action}"
  end

  def item_name
    case self.itemable_type
      when "User"
        self.itemable.username
      when /Place|Performer|Event|Song/
        self.itemable.name
      else
        ""
    end
  end

  def actor
    { :type => 'User', :id => self.user_id }
  end

  def item
    { :type => self.itemable_type, :id => self.itemable_id }
  end

  def context
    { :type => self.contextable_type, :id => self.contextable_id }
  end

end

