class AchievementObserver < ActiveRecord::Observer
  observe :video, :song, :video_song, :like

  def after_upload(video)
    AchievementPoint.for_uploading video
  end

  def after_first_upload_to_event(video)
    AchievementPoint.for_uploading_to_event_first video
  end

  def after_definition(song)
    AchievementPoint.for_definition song
  end

  def after_add_to_video(video_song)
    AchievementPoint.for_add_to_video video_song
  end

  def after_exceeding_likes_count(like)
    AchievementPoint.for_exceeding_likes_count like
  end
end
