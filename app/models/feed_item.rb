class FeedItem < ActiveRecord::Base

  ALLOWED_ITEMABLES = ["User", "Video", "Song", "Comment"]
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

end

