require 'spec_helper'

describe Event do
  before(:all) do
    @event = Factory(:event)
  end
  
  subject { @event }
  
  it { should respond_to :name }
  it { should validate_presence_of(:name) }
  
end
