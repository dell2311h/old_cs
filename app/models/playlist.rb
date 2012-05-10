class Playlist
  attr_reader :timelines
  def format videos
    @timelines = []
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
      @timelines.each_with_index do |track, track_number|
        track_videos = track[:clips]
        track_videos.each_with_index do |track_video, video_number|

          is_first_element = false
          next_track_video = nil
          is_first_element = true if video_number == 0
          next_track_video = track_videos[video_number+1] unless video_number == track_videos.size - 1

           result = should_add(video, track_video, next_track_video, is_first_element)
            unless result == false
            track_place_to_add = video_number + result
            throw "Break loops"
          end
        end
        track_to_add = track_number + 1
        track_place_to_add = 0
      end
    rescue
    ensure
      add_to_track video, track_to_add, track_place_to_add
    end
  end

  def should_add video, track_video, next_track_video, is_first_element
    return Playlist::ADD_BEFORE if is_first_element && track_video.start_time >= video.end_time
    return Playlist::ADD_NEXT  if next_track_video.nil? && track_video.end_time <= video.start_time
    return Playlist::ADD_NEXT  if track_video.end_time <= video.start_time && next_track_video.start_time >= video.end_time

    Playlist::DO_NOT_ADD
  end

  def add_to_track video, track = 0, place = 0
    if @timelines[track].nil?
      tmp = {}
      tmp[:position] = @timelines.size
      tmp[:size] = 0
      tmp[:clips] = []
      @timelines[track] = tmp
    end
    @timelines[track][:clips].insert place - 1, video
    @timelines[track][:size] = @timelines[track][:size] + 1
  end

  private
    DO_NOT_ADD = false
    ADD_NEXT = 2
    ADD_BEFORE = 1

end
