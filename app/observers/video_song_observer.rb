class VideoSongObserver < ActiveRecord::Observer

  def after_create(model)
    FeedItem.create_for_song_definition(model)
  end

end

