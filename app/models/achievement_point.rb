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

  after_create :update_user_points_sum

  def reason
    AchievementPoint::REASONS.invert[self.reason_code].to_s
  end

  def self.for_uploading(video)
    AchievementPoint.create(:user_id => video.user_id,
                            :reason_code => AchievementPoint::REASONS[:upload_video],
                            :points => Settings.achievements.points.upload_video)
  end

  def self.for_uploading_to_event_first(video)
    unless video.event_id.nil? && video.clip.nil?
      # this video must be first in event
      if Video.unscoped.where(:event_id => video.event_id).where("clip IS NOT NULL").count == 1
        AchievementPoint.create(:user_id => video.user_id,
                                :reason_code => AchievementPoint::REASONS[:first_upload_to_event],
                                :points => Settings.achievements.points.first_upload_to_event)
      end
    end
  end

  def self.for_definition(song)
    AchievementPoint.create(:user_id => song.user_id,
                            :reason_code => AchievementPoint::REASONS[:define_song],
                            :points => Settings.achievements.points.define_song)
  end

  def self.for_add_to_video(video_song)
    AchievementPoint.create(:user_id => video_song.user_id,
                            :reason_code => AchievementPoint::REASONS[:add_song],
                            :points => Settings.achievements.points.add_song)
  end

  private
    def update_user_points_sum
      user.update_attribute(:achievement_points_sum, self.user.achievement_points_sum.to_i + self.points.to_i)
    end

end
