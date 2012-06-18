class VideoObserver < ActiveRecord::Observer

  def after_set_status_done(video)
    FeedItem.create(:action      => "video_upload",
                    :user_id     => video.user_id,
                    :entity      => video)
  end

end