require 'spec_helper'

describe Comment do
  it { should respond_to :user_id }
  it { should respond_to :video_id }
  it { should respond_to :text }

  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :text }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :video_id }

  describe "#destroy_by(user)" do
    before :each do
      @comment = Factory.create :comment
      @comment_user = @comment.user
      @video_user = @comment.video.user
    end
    it "should delete comment by its owner" do
      @comment.destroy_by @comment_user
      Comment.all.should_not include(@comment)
    end

    it "should delete comment by owner of commented video" do
      @comment.destroy_by @video_user
      Comment.all.should_not include(@comment)
    end

    it "should not delete comments by other users" do
      wrong_user = Factory.create :user
      @comment.destroy_by wrong_user
      Comment.all.should include(@comment)
    end

  end

  describe "#mentions" do
    before :all do
      comment = Factory.create :comment, :text => "SDFDSF @men1 sdfsdf rrtgfd @men2 @men1 dsa @men3 sd @men_4"
      @mentions = comment.mentions
    end
    it "should return array of mentions" do
      @mentions.should include("men1")
      @mentions.should include("men2")
      @mentions.should include("men3")
    end

    it "should return only uniq mentions" do
      @mentions.count("men1").should be_eql(1)
    end

    it "should replace '_' with ' ' in result mentions" do
      @mentions.should include("men 4")
      @mentions.should_not include("men_4")
    end
  end

end

