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

  scope :for_user, lambda { |user, params| where("user_id = ? OR (itemable_type = 'User' AND itemable_id = ?) OR (contextable_type = 'User' AND contextable_id = ?)", user.id, user.id, user.id)

  }

  scope :search_by, lambda { |entity, params|
    search = case entity.class.to_s
      when 'User'
        for_user(entity, params)
    end
    search.includes [:user, :itemable, :contextable]
  }

  def message_for_feed(feed_type)
    raise "Not allowed feed type" unless [:user, :news, :notification, :place, :event, :performer].include?(feed_type)
    I18n.t "feed.#{feed_type}.#{self.action}"
  end

  def name_for(entity)
    case entity.class.to_s
      when "User"
        entity.username
      when /Place|Performer|Event|Song/
        entity.name
      else
        ""
    end
  end

  def itemable_name
    name_for(self.itemable)
  end

  def contextable_name
    name_for(self.contextable)
  end

end

