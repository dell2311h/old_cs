require 'spec_helper'

describe Timing do

  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }
  it { should validate_presence_of(:version) }

  it { should belong_to(:video) }

end