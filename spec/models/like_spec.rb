require 'spec_helper'

describe Like do
  let(:like) { Factory.create :like }

  it { should respond_to(:user_id) }
  it { should respond_to(:video_id) }

  it { should belong_to(:user) }
  it { should belong_to(:video) }

end
