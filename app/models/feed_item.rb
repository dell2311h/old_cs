class FeedItem < ActiveRecord::Base

  NOTIFICATIBLE_ACTIONS = ["comment_video", "like_video", "follow", "mention", "add_song"]
  ALLOWED_ENTITIES = ["User", "Video", "Song", "Comment", "Event", "Place", "Performer"]
  ALLOWED_CONTEXTS = ["Video", "Event", "Comment", "Authentication"]
  ALLOWED_ACTIONS = ["video_upload", "comment_video", "follow", "mention",
                     "like_video", "join_crowdsync", "add_song", "tagging", "mention"]

  belongs_to :user

  belongs_to :entity, :polymorphic => true
  belongs_to :context, :polymorphic => true
  has_one    :user_notification

  validates :user_id, :entity_id, :entity_type, :action, :presence => true
  validates :context_id, :context_type, :presence => true, :if => lambda { |f| f.context_type or f.context_type }
  validates :entity_type, :inclusion => ALLOWED_ENTITIES
  validates :action, :inclusion => ALLOWED_ACTIONS
  validates :context_type, :inclusion => ALLOWED_CONTEXTS, :if => lambda { |f| f.context_type }

  default_scope order("created_at DESC")

  scope :user_feed, lambda { |user|
     user_video_ids = user.videos.pluck(:id)
     where("user_id = ? OR (entity_type = 'User' AND entity_id = ?) OR (context_type = 'User' AND context_id = ?) OR (entity_type = 'Video' AND entity_id IN (?))", user.id, user.id, user.id, user_video_ids) }

  scope :news_feed, lambda { |user|
    followings = Relationship.select("followable_type, followable_id").where(:follower_id => user.id)
    followed_user_ids = user.relationships.where(:followable_type => 'User').pluck(:followable_id)
    followed_event_ids = user.relationships.where(:followable_type => 'Event').pluck(:followable_id)
    followed_place_ids = user.relationships.where(:followable_type => 'Place').pluck(:followable_id)
    followed_performer_ids = user.relationships.where(:followable_type => 'Performer').pluck(:followable_id)

    where("user_id IN (?) OR #{entity_context_sql_part_for('User')} OR #{entity_context_sql_part_for('Event')} OR #{entity_context_sql_part_for('Place')} OR #{entity_context_sql_part_for('Perfromer')}", followed_user_ids, followed_user_ids, followed_user_ids,  followed_event_ids,  followed_event_ids, followed_place_ids, followed_place_ids,  followed_performer_ids, followed_performer_ids)
  }

  scope :notification_feed, lambda { |user|
    user_video_ids = user.videos.pluck(:id)
    where("(entity_type = 'User' AND entity_id = ?) OR (context_type = 'User' AND context_id = ?) OR (entity_type = 'Video' AND entity_id IN (?))", user.id, user.id, user_video_ids)
  }

  scope :for_place, lambda { |place| where("(entity_type = 'Place' AND entity_id = ?) AND (action = 'tagging')", place.id) }

  scope :for_event, lambda { |event| where("((entity_type = 'Event' AND entity_id = ?) OR (context_type = 'Event' AND context_id = ?)) AND (action IN ('tagging', 'video_upload', 'comment_video'))", event.id, event.id) }

  scope :for_performer, lambda { |performer| where("((entity_type = 'Performer' AND entity_id = ?) OR (context_type = 'Performer' AND context_id = ?)) AND (action IN ('mention', 'like_video', 'comment_video'))", performer.id, performer.id) }

  scope :search_by, lambda { |entity, params|
    search = case entity.class.to_s
      when 'User'
        for_user(entity, params)
      when 'Place'
        for_place(entity)
      when 'Event'
        for_event(entity)
      when 'Performer'
        for_performer(entity)
    end
    search.includes [:user, :entity, :context]
  }

  def self.for_user(user, params)
    feed_type = params[:feed_type] || 'user'
    case feed_type
      when 'user'
        user_feed(user)
      when 'news'
        news_feed(user)
      when 'notification'
        notification_feed(user)
    end
  end



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

  def send_notification
    if should_send_notification?
      UserNotification.process_email_notification self
    end
  end

  private

  def should_send_notification?
    NOTIFICATIBLE_ACTIONS.include?(self.action) &&
    (self.action != "mention" || self.entity_type == "User") &&
    (self.action != "follow"  || self.entity_type == "User")
  end

    def self.entity_context_sql_part_for(klass_name)
      "(entity_type = '#{klass_name}' AND entity_id IN (?)) OR (context_type = '#{klass_name}' AND context_id IN (?))"
    end

end

