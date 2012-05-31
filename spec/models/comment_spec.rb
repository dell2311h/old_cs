require 'spec_helper'

describe Comment do
  it { should respond_to :user_id }
  it { should respond_to :commentable_id }
  it { should respond_to :commentable_type }
  it { should respond_to :text }

  it { should belong_to :user }
  it { should belong_to :commentable }
  it { should validate_presence_of :text }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }

  describe "#commentable_unscoped" do

    let(:hidden_video) { Factory.create :video, :status => Video::STATUS_UPLOADING }
    let(:comment) { Factory.create :comment, :commentable => hidden_video }

    it "should find unscoped commentable" do
      comment.commentable_unscoped.should == hidden_video
    end

  end

  describe "#destroy_by(user)" do

    it "should delete comment by its owner" do

    end

    it "should delete comment by owner of commented video" do

    end

    it "should not delete comments by other users" do

    end

  end



end

