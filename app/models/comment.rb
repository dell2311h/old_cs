class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  has_many :feed_entities, :as => :entity, :class_name => "FeedItem", :dependent => :destroy
  has_many :feed_contexts, :as => :context, :class_name => "FeedItem", :dependent => :destroy

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

  def self.find_commentable_by(user = nil, params)
    class_name = case params[:commentable]
      when /videos|places|events/
        params[:commentable][0..-2]
    end

    model_class = class_name.capitalize.constantize

    if user and (model_class == Video) and (unscoped_instance = model_class.unscoped.find(params[:id])).user_id == user.id
      unscoped_instance
    else
      model_class.find(params[:id])
    end
  end

end

