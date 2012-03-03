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
end
