class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user
  belongs_to :taggable, :polymorphic => true
  
  validates :user_id, :tag_id, :taggable_id, :taggable_type, :presence => true
end
