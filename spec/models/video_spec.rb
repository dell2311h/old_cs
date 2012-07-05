require 'spec_helper'

describe Video do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:uuid) }
  it { should validate_numericality_of(:event_id) }
  it { should belong_to(:user) }
  it { should belong_to(:event) }
  it { should have_many(:timings) }
  it { should have_many(:tags).through(:taggings) }
  it { should have_many(:taggings).dependent(:destroy) }

  context "chunked uploads" do
    subject { Video.new }
    it { should respond_to(:directory_fullpath) }
    it { should respond_to(:tmpfile_fullpath) }
    it { should respond_to(:make_uploads_folder!) }
    it { should respond_to(:remove_attached_data!) }
    it { should respond_to(:append_chunk_to_file!) }
    it { should respond_to(:append_binary_to_file!) }
    it { should respond_to(:tmpfile_md5_checksum) }
    it { should respond_to(:tmpfile_size) }
    it { should respond_to(:finalize_upload_by!) }
  end

  describe "#find_by" do
    before :all do
      @video = Factory.create :video
      @owner = @video.user
      @user = Factory.create :user
    end
    context "find video with status ready " do
      it "should find video when no user is passed" do
        video = Video.find_by(nil, @video.id)
        video.id.should be_eql(@video.id)
      end
      it "should find video when video owner is passed" do
        video = Video.find_by(@owner, @video.id)
        video.id.should be_eql(@video.id)
      end
      it "should'n find unexisting video" do
        lambda { Video.find_by(nil, @video.id + 1) }.should raise_error
        lambda { Video.find_by(@owner, @video.id + 1) }.should raise_error
      end
    end

    context "find with not ready status" do
      before :all do
        @video.status = Video::STATUS_NEW
        @video.save
      end
      it "should find existing video for it's owner" do
        video = Video.find_by(@owner, @video.id)
        video.id.should be_eql(@video.id)
      end
      it "shouldn't find existing viedo for other users" do
        lambda { video = Video.find_by(@user, @video.id) }.should raise_error
      end
      it "shouldn' find existing video without owner" do
        lambda { video = Video.find_by(nil, @video.id) }.should raise_error
      end
    end
  end

  describe "#search" do

    before :each do
      AchievementPoint.stub!(:reward_for)
    end

    context "search by user_id" do
      before :all do
        Video.destroy_all
        Factory.create :video, :user_id => 14
        Factory.create :video, :user_id => 161
      end

      it 'should find video with propper user_id' do
        results = Video.search({ :user_id => 14 })
        results.should include Video.find_by_user_id 14
        results.should_not include Video.find_by_user_id 161
      end
    end

    context 'search by event_id' do
      before :all do
        Video.destroy_all
        Factory.create :video, :event_id => 88
        Factory.create :video, :event_id => 161
      end

      it "should find video with propper event_id" do
        results = Video.search({ :event_id => 88 })
        results.should include Video.find_by_event_id 88
        results.should_not include Video.find_by_event_id 161
      end
    end

    context 'search by song_id' do

      before :all do
        @song = Factory.create :song
        @valid_video = Factory.create :video
        Factory.create :video_song, :video => @valid_video, :song => @song
        @invalid_video = Factory.create :video
      end

      it 'should find propper videos by song_id' do
        results = Video.search({ :song_id => @song.id })
        results.should include @valid_video
        results.should_not include @invalid_video
      end

    end

    context 'search by comment tag' do

      before :all do
        tagging = Factory.create :tagging
        @tag = tagging.tag.name
        @valid_video = tagging.video
        tagging = Factory.create :tagging
        @invalid_video = tagging.video
      end

      it 'should find propper videos by tag comment' do
        results = Video.search({ :comment_tag => @tag })
        results.should include @valid_video
        results.should_not include @invalid_video

      end
    end

  end
end
