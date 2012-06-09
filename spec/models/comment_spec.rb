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

    it "should delete comment by its owner" do
      comment = Factory.create :comment
      user = comment.user
    end

    it "should delete comment by owner of commented video" do

    end

    it "should not delete comments by other users" do

    end

  end



end

