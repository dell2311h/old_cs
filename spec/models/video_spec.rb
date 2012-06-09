require 'spec_helper'

describe Video do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:uuid) }
  it { should validate_numericality_of(:event_id) }
  it { should belong_to(:user) }
  it { should belong_to(:event) }
  it { should have_many(:timings) }
  
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

  describe "#search" do

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
        @valid_video = @song.videos.first
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
        @valid_video = Factory.create :video
        @invalid_video = Factory.create :video
        Factory.create :comment
        comment = Factory.create :comment, :video => @valid_video
        comment = @valid_video.comments.first
        @tag = 'TagTest'
        comment.text = comment.text + " #" + @tag
        comment.save
      end

      it 'should find propper videos by tag comment' do
        results = Video.search({ :comment_tag => @tag })
        results.should include @valid_video
        results.should_not include @invalid_video

      end
    end

  end
end

