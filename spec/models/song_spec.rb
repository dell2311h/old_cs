require 'spec_helper'

describe Song do

  describe "#.with_calculated_counters()" do

    before :each do
      FeedItem.stub!(:create_for_comment)
      FeedItem.stub!(:create_for_song_definition)
      AchievementPoint.stub!(:reward_for)
    end

    it "should return list of songs with correctly calculated counters" do
      @song_one = Factory.create :song
      @song_two = Factory.create :song
      @video = Factory.create :video, :clip => nil, :event_id => rand(100)
      @video.video_songs.create :song => @song_one, :user => @song_one.user
      @comment = Factory.create :comment_without_callbacks, :user_id => rand(100), :video => @video

      Song.with_calculated_counters.find(@song_one).attributes['comments_count'].to_i.should be(1)
      Song.with_calculated_counters.find(@song_one).attributes['videos_count'].to_i.should be(1)
      Song.with_calculated_counters.find(@song_two).attributes['comments_count'].to_i.should be(0)
      Song.with_calculated_counters.find(@song_two).attributes['videos_count'].to_i.should be(0)
    end
  end

end

