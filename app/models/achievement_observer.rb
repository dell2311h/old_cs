class AchievementObserver < ActiveRecord::Observer
  observe :video, :song

  def after_upload(video)
    AchievementPoint.for_uploading video
  end

  def after_first_upload_to_event(video)
    AchievementPoint.for_uploading_to_event_first video
  end

  def after_definition(song)
    AchievementPoint.for_definition song
  end
end
