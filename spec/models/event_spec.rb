require 'spec_helper'

describe Event do

  it { should respond_to :name }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:place_id) }

  it { should belong_to(:user) }
  it { should belong_to(:place) }
  it { should have_many(:videos) }

  describe "#order_by_video_count" do
    it 'should give events ordered by video count in descending order' do
      event1 = Factory.create :event
      event2 = Factory.create :event
      video = Factory.create :video
      video.update_attribute(:event_id, event1.id)

      ordered_events = Event.order_by_video_count
      ordered_events[0].videos.count.should be > ordered_events[1].videos.count
    end
  end

  describe "#nearby" do
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
end

