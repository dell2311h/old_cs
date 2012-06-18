class FeedItem < ActiveRecord::Base

  ALLOWED_ENTITIES = ["User", "Video", "Song", "Comment", "Event", "Place", "Performer"]
  ALLOWED_CONTEXTS = ["Video", "Event", "Comment", "Authentication"]
  ALLOWED_ACTIONS = ["video_upload", "comment_video", "follow", "mention",
                     "like_video", "join_crowdsync", "add_song", "tagging", "mention"]

  belongs_to :user

  belongs_to :entity, :polymorphic => true
  belongs_to :context, :polymorphic => true

  validates :user_id, :entity_id, :entity_type, :action, :presence => true
  validates :context_id, :context_type, :presence => true, :if => lambda { |f| f.context_type or f.context_type }
  validates :entity_type, :inclusion => ALLOWED_ENTITIES
  validates :action, :inclusion => ALLOWED_ACTIONS
  validates :context_type, :inclusion => ALLOWED_CONTEXTS, :if => lambda { |f| f.context_type }

  scope :for_user, lambda { |user, params| where("user_id = ? OR (entity_type = 'User' AND entity_id = ?) OR (context_type = 'User' AND context_id = ?)", user.id, user.id, user.id) }

  scope :search_by, lambda { |entity, params|
    search = case entity.class.to_s
      when 'User'
        for_user(entity, params)
    end
    search.includes [:user, :entity, :context]
  }

  def message_for_feed(feed_type)
    raise "Not allowed feed type" unless [:user, :news, :notification, :place, :event, :performer].include?(feed_type)
    I18n.t "feed.#{feed_type}.#{self.action}"
  end

  def self.name_for(object)
    case object.class.to_s
      when "User"
        object.username
      when /Place|Performer|Event|Song/
        object.name
      when 'Video'
        'video'
      else
        ""
    end
  end

  def self.create_for_like(like)
    FeedItem.create!(:action => 'like_video', :user => like.user, :entity => like.video, :context => like.video.event)
  end

  def self.create_for_follow(relationship)
    FeedItem.create!(:action => 'follow', :user => relationship.follower, :entity => relationship.followable)
  end

  def self.create_for_song_definition(video_song)
    FeedItem.create!(:action => 'add_song', :user => video_song.user, :entity => video_song.song, :context => video_song.video)
  end


end

