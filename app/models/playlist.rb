class Playlist
  
  def format videos
    @playlist = []
    videos.each do|video|
      unless video.start_time.nil? && video.end_time.nil?
        add_video video
      end
    end

  end

  def add_video video
    track_to_add = 0
    track_place_to_add = 0
    begin
      @playlist.each do |track|
        track.each do |track_video|
          throw 'Break loops' if should_add? video, track_video
          track_place_to_add = track_place_to_add + 1
        end
        track_place_to_add = 0
        track_to_add = track_to_add + 1

      end
    rescue
    ensure
      add_to_track video, track_to_add, track_place_to_add
    end
  end

  def should_add? video, track_video
    return true if video.end_time   <= track_video.start_time
    return true if video.start_time >= track_video.end_time

    false
  end

  def add_to_track video, track = 0, place = 0
    @playlist[track] = [] if @playlist[track].nil?
    @playlist[track].insert place - 1, video

  end

  private
  @playlist
end
