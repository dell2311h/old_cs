class AchievementObserver < ActiveRecord::Observer
  observe :video, :song, :video_song, :like, :comment, :relationship, :meta_info

  def after_upload(video)
    AchievementPoint.reward_for :upload_video, video.user_id
  end

  def after_first_upload_to_event(video)
    AchievementPoint.reward_for :first_upload_to_event, video.user_id
  end

  def after_definition(song)
    AchievementPoint.reward_for :define_song, song.user_id
  end

  def after_add_to_video(video_song)
    AchievementPoint.reward_for :add_to_video, video_song.user_id
  end

  def after_exceeding_likes_count(like)
    AchievementPoint.reward_for :exceeding_likes_count, like.video.user_id
  end

  def after_exceeding_comments_count_for_video(comment)
    AchievementPoint.reward_for :exceeding_comments_count_for_video, comment.video.user_id
  end

  def after_exceeding_comments_count_for_user(comment)
    AchievementPoint.reward_for :exceeding_comments_count_for_user, comment.user_id
  end

  def after_exceeding_views_count(video)
    AchievementPoint.reward_for :exceeding_views_count, video.user_id
  end

  def after_exceeding_followings_count(relationship)
    AchievementPoint.reward_for :exceeding_followings_count, relationship.follower_id
  end

  def after_exceeding_followers_count(relationship)
    AchievementPoint.reward_for :exceeding_followers_count, relationship.followable_id
  end

  def after_upload_longest_video_to_event(meta_info)
    AchievementPoint.reward_for :upload_longest_video_to_event, meta_info.video.user_id
  end
end
