class AchievementObserver < ActiveRecord::Observer
  observe :video

  def after_upload(video)
    AchievementPoint.create(:user_id => video.user_id,
                            :reason_code => AchievementPoint::REASONS[:upload_video],
                            :points => Settings.achievements.points.upload_video)
    first_video = Video.unscoped.where(:event_id => video.event_id).order("created_at ASC").first
    if video.id == first_video.id
      AchievementPoint.create(:user_id => video.user_id,
                              :reason_code => AchievementPoint::REASONS[:first_upload_to_event],
                              :points => Settings.achievements.points.first_upload_to_event)
    end
  end
end
