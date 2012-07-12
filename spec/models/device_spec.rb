require 'spec_helper'

describe Device do
  it { should respond_to :user_id }
  it { should respond_to :token }

  it { should belong_to :user }

  describe "#register_device" do
    it "should register device for user and unregister old one" do
      user = Factory.create :user
      device = Device.register_device user, "26bef9d0 71fa7471 90061b7b d304f562 f272645f 4274ced8 cdf8c933 b75f3d4e"
      device.user.should be_eql(user)
    end
  end

  describe "#unregister_device" do
    it "should unregister user device" do
      device = Factory.create :device
      user = device.user
      Device.unregister_device user
      user.reload
      user.device.should be_nil
    end
  end

end
