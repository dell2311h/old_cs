require 'spec_helper'
include Devise::TestHelpers

describe VideosController do

  let(:user) { Factory.create(:user) }

  before :each do
    user.stub!(:videos).and_return([])
    sign_in(user)
    @video = Video.new
    Video.stub!(:new).and_return(@video)
    @video.stub!(:save).and_return(true)
    @video.stub!(:create_encoding_media).and_return(true)
    @event = mock_model(Event)
    @event.stub!(:name).and_return(Faker::Lorem.word)
    @video.stub!(:event).and_return(@event)
    @video.stub!(:to_jq_upload).and_return({
      "name" => Faker::Lorem.word,
      "size" => 12345,
      "url" => "/some_url",
      "thumbnail_url" => "",
      "delete_url" => "/videos/1",
      "delete_type" => "DELETE"
    })
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      @video.stub!(:attach_clip){ true }
      @video.should_receive(:attach_clip)
      @video.should_receive(:create_encoding_media)
      post 'create', :video => {:clip => 'clip'}
      response.should be_success
    end
  end

end
