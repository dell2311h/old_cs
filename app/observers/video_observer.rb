class VideoObserver < ActiveRecord::Observer

  def after_set_status_done(video)
    FeedItem.create_for_upload_video(video)
  end

end

