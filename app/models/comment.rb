class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  validates :text, :user_id, :commentable_id, :commentable_type, :presence => true

  self.per_page = Settings.paggination.per_page

  default_scope order("created_at DESC")

  def destroyable_by?(user)
    (self.user == user) or (self.commentable_type == 'Video' and self.commentable_unscoped.user == user)
  end

  def commentable_unscoped
    self.commentable_type.constantize.unscoped.find(self.commentable_id)
  end

  def destroy_by(user)
    self.destroy if self.destroyable_by?(user)
  end

end

