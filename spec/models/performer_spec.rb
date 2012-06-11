require 'spec_helper'

describe Performer do
  it { should respond_to(:name) }
  it { should respond_to(:picture) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should have_and_belong_to_many(:events) }

  describe "#search" do
    before :all do
      2.times { Factory.create :performer }
      @performer = Performer.last
    end
    
    it "should include performer if name mathces" do
      performers = Performer.search({ :performer_name => @performer.name })
      performers.count.should be > 0
      performers.should include(@performer)
    end

    it "should include performer if name partial mathces" do
      performers = Performer.search({ :performer_name => @performer.name[1, (@performer.name.length - 2)] })
      performers.count.should be > 0
      performers.should include(@performer)
    end

    it "should not include performer if name doesn't match" do
      random_string = (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
      Performer.search({ :performer_name => @performer.name + random_string }).count.should eq 0
    end
  end
end