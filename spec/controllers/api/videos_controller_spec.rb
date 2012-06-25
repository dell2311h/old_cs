require 'spec_helper'

describe Api::VideosController do
  describe "#create" do
    before :each do
      @video = Factory.create(:video)
      @file = fixture_file_upload('/clip.mp4', 'video/mp4')
      @user = User
      @user.stub(:find_by_authentication_token).and_return(@user)
    end

    context 'with incorrect params' do
      it "should return error with empty event_id" do
        post :create, :clip => @file, :name => 'name'
        response.code.should eq('400')
        result = JSON.parse(response.body)
        result['error'].should_not be_nil
      end
    end
  end
  describe "#view" do
    before :each do
      @video = Factory.create(:video)
      @user = User
      @user.stub(:find_by_authentication_token).and_return(@user)
    end

    it "should increment view_count" do
      video_view_count = @video.view_count.to_i
      put :view, :id => @video.id, :format => :json
      response.code.should eq "200"
      @video.reload
      @video.view_count.should == video_view_count + 1
    end
  end
end
