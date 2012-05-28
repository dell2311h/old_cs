require 'spec_helper'

def create_video(event, timings, likes_count = nil)
  video = Factory.create :video, event: @event
  Factory.create(:timing,
                 video:      video,
                 start_time: timings[:start_time],
                 end_time:   timings[:end_time],
                 version:    @event.master_track_version)
  likes_count.times { Factory.create :like, video: video } unless likes_count.nil?

  video
end

describe Playlist do
  describe "#format" do
    before :all do
      @event = Factory.create :event
      @playlist_etalon = []
      @playlist_etalon[0] = [create_video(@event, { start_time: 1, end_time: 3 }, 4)]
      @playlist_etalon[0] << create_video(@event, { start_time: 4, end_time: 6 })
      @playlist_etalon[1] = [create_video(@event, { start_time: 0, end_time: 2 })]
      @playlist_etalon[1] << create_video(@event, { start_time: 2, end_time: 3 })

      @playlist_videos = Video.find_videos_for_playlist @event.id
    end

    it "it should format playlist properly" do
      playlist = Playlist.new
      playlist.format(@playlist_videos)
      current_playlist = playlist.timelines

      current_playlist[0][:clips][0].id.should be == @playlist_etalon[0][0].id
      current_playlist[0][:clips][1].id.should be == @playlist_etalon[0][1].id
      current_playlist[1][:clips][0].id.should be == @playlist_etalon[1][0].id
      current_playlist[1][:clips][1].id.should be == @playlist_etalon[1][1].id
    end
  end
end
