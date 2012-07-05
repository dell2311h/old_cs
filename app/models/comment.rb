class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  has_many :feed_entities, :as => :entity, :class_name => "FeedItem", :dependent => :destroy
  has_many :feed_contexts, :as => :context, :class_name => "FeedItem", :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  after_create :create_tags, :accure_achievement_points

  validates :text, :user_id, :video_id, :presence => true

  self.per_page = Settings.paggination.per_page

  default_scope order("created_at DESC")

  def destroyable_by?(user)
    (self.user == user) or (Video.find(self.video_id).user == user)
  end

  def destroy_by(user)
    self.destroy if self.destroyable_by?(user)
  end

  def mentions
    self.text.scan(/@(\S*)(?:\z|\s)/).uniq.flatten.map! {|x| x.gsub("_"," ") }
  end

  private

    def create_tags
      Tag.create_by_comment self
    end

    def accure_achievement_points
      if Comment.where(:video_id => self.video_id).count >= Settings.achievements.limits.exceeding_comments_count_for_video &&
         AchievementPoint.where(:user_id => self.video.user_id,
                                :reason_code => AchievementPoint::REASONS[:exceeding_comments_count_for_video]).count == 0
        notify_observers(:after_exceeding_comments_count_for_video)
      end
      if Comment.where(:user_id => self.user_id).count >= Settings.achievements.limits.exceeding_comments_count_for_user &&
         AchievementPoint.where(:user_id => self.user_id,
                                :reason_code => AchievementPoint::REASONS[:exceeding_comments_count_for_user]).count == 0
        notify_observers(:after_exceeding_comments_count_for_user)
      end
    end
end

