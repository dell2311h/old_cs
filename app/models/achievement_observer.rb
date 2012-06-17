class AchievementObserver < ActiveRecord::Observer
  observe :video

  def after_upload(video)
    AchievementPoint.create(:user_id => video.user_id,
                             :reason_code => AchievementPoint::REASONS[:upload_video],
                             :points => Settings.achievements.points.upload_video)
  end
end
