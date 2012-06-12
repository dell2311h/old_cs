require 'spec_helper'

describe Tag do
  it { should have_many(:taggings).dependent(:destroy) }
  it { should have_many(:videos).through(:taggings) }
  it { should have_many(:comments).through(:taggings) }

  it { should validate_presence_of(:name) }

end
