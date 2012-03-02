require 'spec_helper'

describe Event do
  before(:all) do
    @event = Factory(:event)
  end
  
  subject { @event }
  
  it { should respond_to :name }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:place_id) }
  
  it { should respond_to :api_data }
  
  it "should return api data in appropriate format" do
    @event.api_data.keys.should =~ ["id", "name", "place_id", "user_id"]
  end
  
end
