class AchievementPoint < ActiveRecord::Base

  REASONS = {
    :upload_video                       => 1,
    :first_upload_to_event              => 2,
    :add_song                           => 3,
    :define_song                        => 4,
    :exceeding_likes_count              => 5,
    :exceeding_comments_count_for_video => 6,
    :exceeding_views_count              => 7,
    :exceeding_followers_count          => 8,
    :exceeding_followings_count         => 9,
    :exceeding_comment_count_for_user   => 10,
    :upload_longest_video_to_event      => 11
  }

  belongs_to :user

  after_save :update_user_points_sum

  def reason
    AchievementPoint::REASONS.invert[self.reason_code].to_s
  end

  private
    def update_user_points_sum
      user.update_attribute(:achievement_points_sum, self.user.achievement_points_sum.to_i + self.points.to_i)
    end

end
