require 'spec_helper'

describe Tag do
  it { should have_many(:taggings).dependent(:destroy) }
  it { should have_many(:videos).through(:taggings) }
  it { should have_many(:comments).through(:taggings) }

  it { should validate_presence_of(:name) }

  describe "find_tags_in" do
    it "should find all tags in text" do
      comment_text = "#tag1 sdf sdf fds#tag2 dfgfd#tag3"
      result = Tag.find_tags_in comment_text
      result.should include("tag1")
      result.should include("tag2")
      result.should include("tag3")
    end
    it "should find only unique tags" do
      comment_text = "#tag1, #tag1, dffdg #tag2, sdf s#tag3, #tag2"
      result = Tag.find_tags_in comment_text
      p result.count("tag1")
      result.count("tag1").should be_eql(1)
      result.count("tag2").should be_eql(1)
      result.count("tag3").should be_eql(1)

    end
    
    it "should return nil if no tags" do
      comment_text = "SDFSD fsdF sdf SDf SDf3e fsd e sdfsd fdsf sd34"
      result = Tag.find_tags_in comment_text
      result.should be_empty
    end
  end

  describe "create_by_comment" do
    it "should create tags for tagged comment " do
      #comment = Factory.create :comment, :text => "CDSSDF, #tag222, #tag333, #tag44432"
      #comment.tags

    end
    
  end
end
