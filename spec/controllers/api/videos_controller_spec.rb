require 'spec_helper'

describe Api::VideosController do
  describe "#create" do
    before :all do
      @video = Factory.create(:video)

      @file = fixture_file_upload('/clip.mp4', 'video/mp4')

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
end
