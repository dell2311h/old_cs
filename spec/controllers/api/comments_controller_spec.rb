require 'spec_helper'

describe Api::CommentsController do

  before :each do
    @result_array = []
    @video = Video
    @video.stub!(:find_by).and_return(@video)
    @video.stub!(:comments).and_return(@result_array)
  end

  describe 'GET index' do

    before :each do
      @result_array.stub!(:order).and_return(@result_array)
      @result_array.stub!(:paginate).and_return(@result_array)
    end

    context "when some results avalible" do
      it "should list all comments" do
        @result_array.stub!(:count).and_return(3)
        per_page = Settings.paggination.per_page.to_s
        page = 2.to_s
        @result_array.should_receive(:order).and_return(@result_array)
        @result_array.should_receive(:count).and_return(3)
        @result_array.should_receive(:paginate).with(:page => page, :per_page => per_page).and_return(@result_array)

        get :index, :format => :json, :id => 11, :page => page, :per_page => per_page
        response.should be_ok
      end
    end

    context "when no results avalible" do
      it "should render not found status" do
        @result_array.stub!(:count).and_return(0)
        @result_array.should_receive(:order).and_return(@result_array)
        @result_array.should_receive(:count).and_return(0)
        @result_array.should_not_receive(:paginate)
        get :index, :format => :json, :id => 11
        response.should be_not_found
      end
    end
  end

  describe "GET event_videos_comments_list" do
    before :each do
      @event = Event
      @event.stub!(:find).and_return(@event)
      @event.stub!(:videos_comments).and_return(@result_array)
      @event_id = 11.to_s
    end

    context "when some results avalible" do
      it "should render all results" do
        per_page = Settings.paggination.per_page.to_s
        page = 2.to_s
        @result_array.stub!(:count).and_return(33)
        @result_array.stub!(:paginate).and_return(@result_array)
        @event.should_receive(:find).with(@event_id).and_return(@event)
        @event.should_receive(:videos_comments).and_return(@result_array)
        @result_array.should_receive(:count).and_return(33)
        @result_array.should_receive(:paginate).with(:page => page, :per_page => per_page).and_return(@result_array)
        get :event_videos_comments_list, :format => :json, :event_id => @event_id, :page => page, :per_page => per_page
        response.should be_ok
      end
    end

    context "when no results avaliable" do
      it "should render not found status" do
        
        @result_array.stub!(:count).and_return(0)
        @event.should_receive(:find).with(@event_id).and_return(@event)
        @event.should_receive(:videos_comments).and_return(@result_array)
        @result_array.should_not_receive(:paginate)
        get :event_videos_comments_list, :format => :json, :event_id => @event_id
        response.should be_not_found
      end
    end
  end

  describe "POST create" do
    before :each do
      @video = Factory.create :video
      @user = Factory.create :user
      Video.unstub!(:find_by)
      Video.unstub!(:comments)
    end
    context "when creation successfull" do
      it "should create comment and return ok status" do
        lambda{ post :create, :format => :json,
                     :authentication_token=> @user.authentication_token,
                     :comment => { :text => "!!", :user_id => @user.id },
                     :id => @video.id
              }.should change(@video.comments, :count).by(1)
        response.should be_ok
      end
    end
    context "when creation unsuccesgull" do
      it "should not create comment and return bad request" do
        lambda{ post :create, :format => :json,
                     :authentication_token=> @user.authentication_token,
                     :comment => { },
                     :id => @video.id
        }.should_not change(@video.comments, :count)
        response.should be_bad_request
      end
    end
  end

  describe "DELETE delete" do
    before :all do
      @comment = Factory.create :comment
    end
    context "when uset can delete comment" do
      it "should render ok status" do
        delete :destroy, :format => :json,
                         :authentication_token=> @comment.user.authentication_token,
                         :comment_id =>@comment.id
        Comment.find_by_id(@comment.id).should be_nil
        should respond_with :accepted
      end
    end

    context "when user can't delete comment" do
      user = Factory.create :user
      it "should render bad request status" do
        delete :destroy, :format => :json,
                         :authentication_token=> user.authentication_token,
                         :comment_id =>@comment.id
        Comment.find_by_id(@comment.id).should_not be_nil
        response.should be_bad_request
      end
    end
  end

end