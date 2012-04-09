class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  
  validates :text, :user_id, :commentable_id, :commentable_type, :presence => true

  self.per_page = Settings.paggination.per_page
end
