class Relationship < ActiveRecord::Base

  attr_accessible :followable

  belongs_to :follower, :class_name => "User"

  belongs_to :followable, :polymorphic => true

  validates :follower_id, :followable_id, :followable_type, :presence => true
  validates :follower_id, :uniqueness => {:scope => [:followable_id, :followable_type]}
  validates :followable_type, :inclusion => ["User", "Event", "Place", "Performer"]

  validate :no_self_following

  after_create :accure_achievement_points

  private

    def no_self_following
      errors.add(:base, I18n.t('errors.models.relationship.you_can_not_follow_yourself')) if (self.follower_id == self.followable_id) && (self.followable_type == "User")
    end

    def accure_achievement_points
      if Relationship.where(:follower_id => self.follower_id).count >= Settings.achievements.limits.exceeding_followings_count &&
         AchievementPoint.where(:user_id => self.follower_id,
                                :reason_code => AchievementPoint::REASONS[:exceeding_followings_count]).count == 0
        notify_observers(:after_exceeding_followings_count)
      end
      if Relationship.where(:followable_id => self.followable_id, :followable_type => 'User').count >= Settings.achievements.limits.exceeding_followers_count &&
         AchievementPoint.where(:user_id => self.followable_id,
                                :reason_code => AchievementPoint::REASONS[:exceeding_followers_count]).count == 0
        notify_observers(:after_exceeding_followers_count)
      end
    end

end

