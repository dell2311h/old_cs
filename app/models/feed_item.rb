class FeedItem < ActiveRecord::Base

  ALLOWED_ITEMABLES = ["User", "Video", "Song", "Comment"]
  ALLOWED_CONTEXTABLES = ["Video", "Event", "Comment", "Authentication"]

  belongs_to :user

  belongs_to :itemable, :polymorphic => true
  belongs_to :contextable, :polymorphic => true

  validates :user_id, :itemable_id, :itemable_type, :presence => true
  validates :contextable_id, :contextable_type, :presence => true, :if => lambda { |f| f.contextable_type or f.contextable_type }
  validates :itemable_type, :inclusion => ALLOWED_ITEMABLES
  validates :contextable_type, :inclusion => ALLOWED_CONTEXTABLES, :if => lambda { |f| f.contextable_type }

end

