require 'spec_helper'

describe Event do

  it { should respond_to :name }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:place_id) }

  it { should belong_to(:user) }
  it { should belong_to(:place) }
  it { should have_many(:videos) }

  describe ".order_by_video_count" do
    it 'should give events ordered by video count in descending order' do
      event1 = Factory.create :event
      event2 = Factory.create :event
      video = Factory.create :video
      video.update_attribute(:event_id, event1.id)

      ordered_events = Event.order_by_video_count
      ordered_events[0].videos.count.should be > ordered_events[1].videos.count
    end
  end

  describe ".nearby" do
    before :all do
      @radius = 1 # mile
      @latitude_shift = 0.2
      @places = (1..2).collect { Factory.create :place }
      @places[1].update_attributes(:latitude => @places[0].latitude + @latitude_shift, :longitude => @places[0].longitude)
      @events = (1..2).collect { Factory.create :event }
      2.times do |i|
        @events[i].update_attribute(:place_id , @places[i].id)
      end
      @coordinates = [@places[0].latitude, @places[0].longitude]
    end

    it 'should return list of events from all places in specified radius' do
      nearby_events = Event.nearby @coordinates, @radius
      nearby_events.should include @events[0]
    end

    it 'should not return list of events from all places that are not in specified radius' do
      nearby_events = Event.nearby @coordinates, @radius
      nearby_events.should_not include @events[1]
    end
  end

  describe "#make_new_master_track" do
    before :each do
      @event = Event.new
      master_track = mock(MasterTrack)
      @pe_results = [[{:end=>"130733", :media_id=>"decc95ff-87d9-4261-9dac-68cf0a55200c", :slope=>"0", :start=>"30700"}, {:end=>"60000", :media_id=>"efe987d4-e5fa-48f4-b4ed-af92bfe32229", :slope=>"0", :start=>"0"}, {:end=>"129933", :media_id=>"29c71338-74ba-430e-b40c-2ab0e6518d38", :slope=>"0", :start=>"89900"}]]
      @timings_result = {:media_ids=>["4fb3781b1f112c1212000002", "4fb378331f112c1212000003"], :cutting_timings=>[{:start_time=>0, :end_time=>60000}, {:start_time=>29300, :end_time=>100033}], :master_track=> master_track}
      @event.stub!(:sync_with_pluraleyes).and_return(@pe_results)
      @event.stub!(:create_timings_by_pluraleyes_sync_results).and_return(@timings_result)
      @event.stub!(:send_master_track_creation_to_encoding_with).and_return(true)
    end

    it "should call internal methods in proper order and with proper params" do
      @event.should_receive(:sync_with_pluraleyes)
      @event.should_receive(:create_timings_by_pluraleyes_sync_results).with(@pe_results)
      @event.should_receive(:send_master_track_creation_to_encoding_with).with(@timings_result)
      @event.make_new_master_track
    end
  end

end

