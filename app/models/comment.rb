class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :video


  has_many :feed_itemables, :as => :itemable, :class_name => "FeedItem", :dependent => :destroy
  has_many :taggings
  has_many :tags, :through => :taggings

  after_create :create_tags

  validates :text, :user_id, :video_id, :presence => true

  self.per_page = Settings.paggination.per_page

  default_scope order("created_at DESC")

  def destroyable_by?(user)
    (self.user == user) or (Video.find(self.video_id).user == user)
  end

  def destroy_by(user)
    self.destroy if self.destroyable_by?(user)
  end

  private
  
  def create_tags
    Tag.create_by_comment self
  end

end

