require 'spec_helper'

describe Api::PerformersController do

  before :each do
    @performer = Performer
  end

  describe 'GET index' do
    before :each do
      @result_array = []
      @performer.stub!(:search).and_return(@performer)
      @performer.stub!(:paginate).and_return(@result_array)
      @performer.stub!(:count => 2)
      @result_array.stub!(:with_flag_followed_by).and_return(@result_array)
      @result_array.stub!(:with_calculated_counters).and_return(@result_array)
    end
    context "when some performers are available" do
      it 'should get list of each Performers' do
        per_page = Settings.paggination.per_page.to_s
        page     = "1"
        @performer.should_receive(:count).and_return(2)
        @performer.should_receive(:paginate).with(:page => page, :per_page => per_page).and_return(@result_array)

        get :index, :per_page => per_page, :page => page, :format => :json

        response.should be_ok
      end

    end

    context "when performers are not available" do

      before :each do
        @performer.stub!(:count => 0)
      end

      it 'should respond with not_found HTTP status' do
        get :index, :format => :json
        response.should be_not_found
      end

    end

  end

  describe 'GET show' do
    before :each do
      @result = stub_model Performer
      @performer.stub!(:with_flag_followed_by).and_return(@result)
      @result.stub!(:with_calculated_counters).and_return(@result)
      @result.stub!(:find).and_return(@result)
    end
     context "when performer is available" do
        it 'show find performer' do
          @result.should_receive(:find).and_return(@result)
          get :show, :id => "1", :format => :json
          response.should be_ok
        end
     end

     context "when performers are not available" do
      before :each do
        @performer.stub!(:with_flag_followed_by).and_return(@performer)
        @performer.stub!(:with_calculated_counters).and_return(@performer)
        @performer.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      end
        it 'should respond with not_found HTTP status' do
          get :show, :id => "1", :format => :json

          response.should be_not_found
      end
     end
  end

end
