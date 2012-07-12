require 'spec_helper'

describe Api::ProfilesController do
  describe 'GET index' do

    before :each do
      @performer_result = Factory.create(:performer)
      @user_result = Factory.create(:user)

      Performer.stub_chain(:search, :first).and_return(@performer_result)
      User.stub(:find_by_username).and_return(@user_result)
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
          User.stub_chain(:search, :first).and_return(nil)
          get :index, :name => "Test", :format => :json
          response.should be_ok
        end

        it 'should return ok when only performer found' do
          User.stub(:find_by_username).and_return(nil)
          get :index, :name => "Test", :format => :json
          response.should be_ok
        end
      end

      context 'Nothing found' do
        it 'should return not found when nothing found' do
          User.stub(:find_by_username).and_return(nil)
          Performer.stub_chain(:search, :first).and_return(nil)
          get :index, :name => "Test", :format => :json
          response.should be_not_found
        end
      end

  end
end