require 'spec_helper'

describe Tagging do
  it { should validate_presence_of(:tag_id) }
  it { should validate_presence_of(:video_id) }

  it { should belong_to(:tag) }
  it { should belong_to(:user) }
  it { should belong_to(:video) }
end
