class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  
  validates :text, :user_id, :commentable_id, :commentable_type, :presence => true
end
