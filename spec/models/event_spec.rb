require 'spec_helper'

describe Event do

  describe 'validations' do
    it { should respond_to :name }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:place_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:place) }
    it { should have_many(:videos) }
    it { should have_many(:relationships).class_name("Relationship").dependent(:destroy) }
    it { should have_many(:followers).through(:relationships) }
  end


  describe ".order_by_video_count" do
    it 'should give events ordered by video count in descending order' do
      event1 = Factory.create :event
      event2 = Factory.create :event
      video = Factory.create :video, :event => event1
      video = Factory.create :video, :event => event1

      ordered_events = Event.order_by_video_count
      ordered_events[0].videos.count.should be >= ordered_events[1].videos.count
    end
  end

  describe ".nearby" do
    before :all do
      @radius = 1 # mile
      @latitude_shift = 0.2
      @places = (0..1).collect { Factory.create :place }
      @places[1].update_attributes(:latitude => @places[0].latitude + @latitude_shift, :longitude => @places[0].longitude)
      @events = []
      2.times {|i| @events[i] = Factory.create :event, :place => @places[i]}
      @coordinates = [@places[0].latitude, @places[0].longitude]
    end

    it 'should return list of events from all places in specified radius' do
      nearby_events = Event.nearby @coordinates, @radius
      nearby_events.should include @events[0]
    end

    it 'should not return list of events from all places trhat are not in specified radius' do
      nearby_events = Event.nearby @coordinates, @radius
      nearby_events.should_not include @events[1]
    end
  end

  describe ".with_ready_mastertrack" do
    before :all do
      @event1 = Factory.create(:event_with_ready_master_track)
      @event2 = Factory.create(:event_with_not_ready_master_track)
    end

    it 'should return list of events with ready master_track proper version' do
      events = Event.with_ready_master_track
      events.should include @event1
      events.should_not include @event2
    end
  end

  describe "#create_not_ready_master_track" do

    let(:event) { Factory(:event) }

    before :each do
      Event.stub!(:get_eventful_event).and_return(1)
      Event.stub!(:create_eventful_event).and_return(1)
    end

    before :all do
      event.master_tracks.destroy_all
    end

    context "when event doesn't have any master track records" do
      it "should create master track with zero version" do
        master_track = event.create_not_ready_master_track
        master_track.version.should == 0
        master_track.is_ready.should be_false
      end
    end

    context "when event have some master tracks" do
      it "should create master track with next version" do
        last_master_track = event.master_tracks.first
        master_track = event.create_not_ready_master_track
        new_version = last_master_track.version + 1
        master_track.version.should == new_version
        master_track.is_ready.should be_false
      end
    end

  end

  describe "#create_timings_by_pluraleyes_sync_results" do

    let(:event) { Factory.create(:event) }

    before :all do
      @clips_data = [{:recorded_at => Time.now, :pe_id => SecureRandom.uuid, :encoding_id => SecureRandom.uuid },
{ :recorded_at => Time.now + 2.minutes, :pe_id => SecureRandom.uuid, :encoding_id => SecureRandom.uuid },
{ :recorded_at => Time.now + 3.minutes, :pe_id => SecureRandom.uuid, :encoding_id => SecureRandom.uuid },
{ :recorded_at => Time.now + 4.minutes, :pe_id => SecureRandom.uuid, :encoding_id => SecureRandom.uuid }]

      @videos_ids = []

      @clips_data.each do |data|
        video = Factory.create(:video, :event => event, :status => Video::STATUS_NEW, :clip => nil)
        @videos_ids << video.id
        Factory.create(:clip_without_add_to_pe_callback, :clip_type => Clip::TYPE_DEMUX_AUDIO, :pluraleyes_id => data[:pe_id], :encoding_id => data[:encoding_id], :video => video, :synced => false )
        video.create_meta_info :recorded_at => data[:recorded_at]
      end

      @pe_results = [[{:end=>"60000", :media_id=> @clips_data[0][:pe_id], :slope=>"0", :start=>"0"}],  [{:end=>"240000", :media_id=> @clips_data[1][:pe_id], :slope=>"0", :start=>"120000"}, {:end=>"420000", :media_id=> @clips_data[2][:pe_id], :slope=>"0", :start=>"180000"}, {:end=>"300000", :media_id=> @clips_data[3][:pe_id], :slope=>"0", :start=>"240000"}]]

      @results = event.create_timings_by_pluraleyes_sync_results(@pe_results)

      @absolute_timings_etalon = [
        {:start_time => 0, :end_time =>	60000},
        {:start_time => 180000, :end_time =>	300000},
        {:start_time => 240000, :end_time =>	480000},
        {:start_time => 300000, :end_time =>	360000}
      ]

    end

    let(:results) { @results }

    let(:media_ids) { @clips_data.map { |data| data[:encoding_id]} }
    let(:pluraleyes_ids) { @clips_data.map { |data| data[:pe_id]} }

    context "results" do

      context ":media_ids" do


        it "should not include clip_id that is bridged by another clip" do
          results[:media_ids].should_not include(media_ids[3])
        end

        it "should consist of properly ordered clip ids list" do
          results[:media_ids].should == [media_ids[0], media_ids[1], media_ids[2]]
        end
      end

      context ":cutting_timings" do
        it "should be a properly organized list of timings" do
          results[:cutting_timings].should == [{:start_time=>0, :end_time=>60000}, {:start_time=>0, :end_time=>120000}, {:start_time=>60000, :end_time=>240000}]
        end
      end

      context ":master_track" do
        it "should be a proper MasterTrack record" do
          results[:master_track].should be_an_instance_of(MasterTrack)
        end
      end

    end

    context "internal results" do
      it "should mark clips as synced" do
        sync_flags = Clip.where(:pluraleyes_id => pluraleyes_ids).pluck("synced")
        sync_flags.each { |sf| sf.should be_true }
      end

      it "should create new absolute timings for videos playlist" do
        timings = Timing.where(:video_id => @videos_ids)
        timings.each_with_index do |timing, index|
          timing.version.should == results[:master_track].version
          timing.start_time.should == @absolute_timings_etalon[index][:start_time]
          timing.end_time.should == @absolute_timings_etalon[index][:end_time]
        end
      end
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

    context 'with empty params from pluraleyes' do
      it "should not call internal methods" do
        @event.stub(:sync_with_pluraleyes).and_return([])
        @event.should_not_receive(:create_timings_by_pluraleyes_sync_results)
        @event.should_not_receive(:send_master_track_creation_to_encoding_with)
        @event.make_new_master_track
      end
    end
  end


  describe "relationships " do

    before :each do
      FeedItem.stub!(:create_for_follow)
      Relationship.stub!(:accure_achievement_points)
    end

    let(:user) { Factory.create :user }
    let(:event) { Factory.create :event }

    describe "counters" do

      before :all do
        @user = Factory.create(:user)
        @event = Factory.create(:event)
      end

      describe ".with_followers_count" do

        context "when event doesn't have any followers" do
          it "should have followers_count attribute with 0 value" do
            attributes = Event.with_followers_count.find(@event.id).attributes
            attributes["followers_count"].should == 0
          end
        end

        context "when event has followers" do
          it "should have followers_count attribute with value equal to 1" do
            @user.follow(@event)
            attributes = Event.with_followers_count.find(@event.id).attributes
            attributes["followers_count"].should == 1
          end
        end

      end

     describe ".with_relationships_counters" do
       it "should return result that have 'followers_count' attribute" do
         Event.with_relationships_counters.first.attributes.should include("followers_count")
       end
     end

    end

    describe ".with_flag_followed_by(user)" do
      context "when user donesn't follow event" do
        it "should have 'followed' attribute with 0 value" do
          Event.with_flag_followed_by(user).find(event.id).attributes["followed"].should == 0
        end
      end

      context "when user follows event" do
        it "should have 'followed' attribute with 1 value" do
          user.follow(event)
          Event.with_flag_followed_by(user).find(event.id).attributes["followed"].should == 1
        end
      end
    end

  end

  describe ".search" do
    context "by user owner" do
      it "should return users events" do
        user_id = rand(100)
        user = double('events_owner')
        events = double('events')
        User.should_receive(:find).with(user_id).and_return(user)
        user.should_receive(:events).and_return(events)
        Event.search(:user_id => user_id).should be(events)
      end
    end

    context "by top events" do
      it "should return events ordered by video count" do
        events = double('events')
        top_events = double('top_events')
        Event.should_receive(:scoped).and_return(events)
        events.stub_chain(:with_ready_master_track, :order_by_video_count).and_return(top_events)
        Event.search(:top => true).should be(top_events)
      end
    end

    context "by nearby events" do
      it "should return nearby events" do
        events = double('events')
        nearby_events = double('nearby_events')
        Event.should_receive(:scoped).and_return(events)
        events.should_receive(:nearby).and_return(nearby_events)
        Event.search(:nearby => true, :latitude => Faker::Geolocation.lat, :longitude => Faker::Geolocation.lng).should be(nearby_events)
      end
    end

    context "by date" do
      it "should return events by date" do
        date = Time.at(rand * Time.now.to_i).to_date
        events = double('events')
        events_by_date = double('events_by_date')
        Event.should_receive(:scoped).and_return(events)
        events.should_receive(:around_date).with(date).and_return(events_by_date)

        Event.search(:date => date.to_s).should be(events_by_date)
      end
    end

    context "by name" do
      it "should return events name" do
        name = Faker::Lorem.word.capitalize
        events = double('events')
        events_by_name = double('events_by_name')
        Event.should_receive(:scoped).and_return(events)
        events.should_receive(:with_name_like).with(name).and_return(events_by_name)
        Event.search(:q => name).should be(events_by_name)
      end
    end

  end

  describe '#get_random_N_top_events' do
    it "should find random event from N top events" do
      Event.destroy_all
      @events_ids = []
      10.times do |i|
        event = Factory.create :event
        @events_ids[9-i] = event.id
        create_videos i, event
      end
      10.times do |i|
        ids = @events_ids.first(i+1)
        event = Event.top_random_for(i+1)
        ids.should include event.id
      end
    end
  end

  private

    def create_videos count, event
      count.times do
        video = Factory.create(:video, :event => event)
      end
    end
end
