class Like < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates :video_id, :uniqueness => { :scope => :user_id}
  validates :user_id, :video_id, :presence => true

  after_create :accure_achievement_points

  private

    def accure_achievement_points
      if Like.where(:video_id => self.video_id).count >= Settings.achievements.limits.exceeding_likes_count &&
         AchievementPoint.where(:user_id => self.video.user_id,
                                :reason_code => AchievementPoint::REASONS[:exceeding_likes_count]).count == 0
        notify_observers(:after_exceeding_likes_count)
      end
    end
end

