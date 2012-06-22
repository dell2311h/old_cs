class FeedItem < ActiveRecord::Base

  ALLOWED_ENTITIES = ["User", "Video", "Song", "Comment", "Event", "Place", "Performer"]
  ALLOWED_CONTEXTS = ["Video", "Event", "Comment", "Authentication", "Performer"]
  ALLOWED_ACTIONS = ["video_upload", "comment_video", "follow", "mention",
                     "like_video", "join_crowdsync_via_social_network", "add_song", "tagging", "like_performers_video", "comment_performers_video", "video_upload_to_performer"]

  belongs_to :user

  belongs_to :entity, :polymorphic => true
  belongs_to :context, :polymorphic => true

  validates :user_id, :entity_id, :entity_type, :action, :presence => true
  validates :context_id, :context_type, :presence => true, :if => lambda { |f| f.context_type or f.context_type }
  validates :entity_type, :inclusion => ALLOWED_ENTITIES
  validates :action, :inclusion => ALLOWED_ACTIONS
  validates :context_type, :inclusion => ALLOWED_CONTEXTS, :if => lambda { |f| f.context_type }

  default_scope order("created_at DESC")

  scope :user_feed, lambda { |user|
     user_video_ids = user.videos.pluck(:id)
     where("#{skip_actions_for_feed('user')} AND (user_id = ? OR (entity_type = 'User' AND entity_id = ?) OR (context_type = 'User' AND context_id = ?) OR (entity_type = 'Video' AND entity_id IN (?)))", user.id, user.id, user.id, user_video_ids) }

  scope :news_feed, lambda { |user|
    followings = Relationship.select("followable_type, followable_id").where(:follower_id => user.id)
    followed_user_ids = user.relationships.where(:followable_type => 'User').pluck(:followable_id)
    followed_event_ids = user.relationships.where(:followable_type => 'Event').pluck(:followable_id)
    followed_place_ids = user.relationships.where(:followable_type => 'Place').pluck(:followable_id)
    followed_performer_ids = user.relationships.where(:followable_type => 'Performer').pluck(:followable_id)

    followings_video_ids = Video.joins(:user).where("users.id IN (?)", followed_user_ids).pluck("videos.id")

    where("#{skip_actions_for_feed('news')} AND (user_id IN (?) OR #{entity_context_sql_part_for('User')} OR #{entity_context_sql_part_for('Event')} OR #{entity_context_sql_part_for('Place')} OR #{entity_context_sql_part_for('Performer')} OR #{entity_context_sql_part_for('Video')})", followed_user_ids, followed_user_ids, followed_user_ids,  followed_event_ids,  followed_event_ids, followed_place_ids, followed_place_ids,  followed_performer_ids, followed_performer_ids, followings_video_ids, followings_video_ids)
  }

  scope :notification_feed, lambda { |user|
    user_video_ids = user.videos.pluck(:id)
    where("#{skip_actions_for_feed('notification')} AND ((entity_type = 'User' AND entity_id = ?) OR (context_type = 'User' AND context_id = ?) OR (entity_type = 'Video' AND entity_id IN (?)))", user.id, user.id, user_video_ids)
  }

  scope :for_place, lambda { |place| where("(entity_type = 'Place' AND entity_id = ?) AND (action = 'tagging')", place.id) }

  scope :for_event, lambda { |event| where("((entity_type = 'Event' AND entity_id = ?) OR (context_type = 'Event' AND context_id = ?)) AND (action IN ('tagging', 'video_upload', 'comment_video'))", event.id, event.id) }

  scope :for_performer, lambda { |performer| where("((entity_type = 'Performer' AND entity_id = ?) OR (context_type = 'Performer' AND context_id = ?)) AND (action IN ('mention', 'like_video', 'comment_video', 'like_performers_video', 'comment_performers_video'))", performer.id, performer.id) }

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

    raise "Not allowed feed type" unless ['user', 'news', 'notification'].include?(feed_type)

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
      when 'Authentication'
        object.provider
      else
        ""
    end
  end

  def self.create_for_join_crowdsync_via_social_network(authentication)
    friends = authentication.user.remote_friends_on_crowdsync_for(authentication.provider)
    friends.each do |friend|
      FeedItem.create(:action => "join_crowdsync_via_social_network", :user_id => authentication.user_id, :entity => friend, :context => authentication)
    end
  end

  def self.create_for_upload_video(video)
    FeedItem.create(:action => "video_upload", :user_id => video.user_id, :entity => video, :context => video.event)
    video.performers.each do |performer|
      FeedItem.create(:action => "video_upload_to_performer", :user_id => video.user_id, :entity => video, :context => performer)
    end
  end

  def self.create_for_like(like)
    video = like.video
    if video
      FeedItem.create!(:action => 'like_video', :user => like.user, :entity => video, :context => video.event)
      video.performers.each do |performer|
        FeedItem.create!(:action => 'like_performers_video', :user => like.user, :entity => video, :context => performer)
      end
    end
  end

  def self.create_for_follow(relationship)
    FeedItem.create!(:action => 'follow', :user => relationship.follower, :entity => relationship.followable)
  end

  def self.create_for_song_definition(video_song)
    FeedItem.create!(:action => 'add_song', :user => video_song.user, :entity => video_song.song, :context => video_song.video)
  end

  def self.create_for_comment(comment)
    video = comment.video
    if video
      create_mention_feeds_for(comment)
      create_video_comment_feeds_for(comment)
      create_performers_video_comment_feeds_for(comment)
    end
  end

  def self.create_for_tagging(tagging)
    video = tagging.comment.video
    if video
      tag = tagging.tag.name
      place = Place.find_by_name tag
      event = Event.find_by_name tag

      if place
        FeedItem.create(:action      => "tagging",
                        :user_id     => tagging.user_id,
                        :entity    => place,
                        :context_type => "Video",
                        :context_id => tagging.comment.video_id);
      end

      if event
        FeedItem.create(:action      => "tagging",
                        :user_id     => tagging.user_id,
                        :entity    => event,
                        :context_type => "Video",
                        :context_id => tagging.comment.video_id);
      end
    end

  end

  private

    class << self

      def entity_context_sql_part_for(klass_name)
        klass_name.constantize # check class name correctness
        "(entity_type = '#{klass_name}' AND entity_id IN (?)) OR (context_type = '#{klass_name}' AND context_id IN (?))"
      end

      def skip_actions_for_feed(feed_type)
        case feed_type
          when /user|news/
            "action NOT IN ('like_performers_video', 'comment_performers_video', 'join_crowdsync_via_social_network')"
          when /notification/
            "action NOT IN ('like_performers_video', 'comment_performers_video', 'video_upload_to_performer', 'video_upload', 'tagging')"
          else
            ""
        end
      end

      def create_performers_video_comment_feeds_for(comment)
        video = comment.video
        video.performers.each do |performer|
          FeedItem.create!(:action => 'comment_performers_video', :user => comment.user, :entity => video, :context => performer)
        end
      end

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


end

