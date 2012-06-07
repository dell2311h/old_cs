require 'spec_helper'

describe Api::ProfilesController do
  describe 'GET index' do

    before :each do
      @performer_result = Factory.create(:performer)
      @user_result = Factory.create(:user)
      
      @performer = Performer
      @user = User
      
      @performer.stub!(:search).and_return(@performer)
      @user.stub!(:find_by_username).and_return(@user_result)
      @performer.stub!(:first).and_return(@performer_result)
      @user.stub!(:first).and_return(@user_result)
    end

      context 'with invalid parameters' do
        it 'should throw exception if name param not set' do
          get :index, :format => :json
          response.should be_bad_request
        end
      end

      context 'Found some results' do
        it 'should ok when user and performer found' do
          get :index, :name => "Test", :format => :json
          response.should be_ok
        end

        it 'should return ok when only user found' do
          @performer.stub!(:search).and_return(@performer)
          @performer.stub!(:first).and_return(nil)
          get :index, :name => "Test", :format => :json
          response.should be_ok
        end

        it 'should return ok when only performer found' do
          @user.stub!(:find_by_username).and_return(nil)
          get :index, :name => "Test", :format => :json
          response.should be_ok
        end
      end

      context 'Nothing found' do
        it 'should return not found when nothing found' do
          @user.stub!(:find_by_username).and_return(nil)
          @performer.stub!(:search).and_return(@performer)
          @performer.stub!(:first).and_return(nil)
          get :index, :name => "Test", :format => :json
          response.should be_not_found
        end
      end

  end
end