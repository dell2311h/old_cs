class Device < ActiveRecord::Base
  belongs_to :user
  validates_format_of :token, :with => /^[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}$/, :allow_nil => true

  def self.register_device(user, token)
    Device.unregister_device user, token
    device = Device.create({:user => user, :token => token})
    device.save!

    device
  end

  def self.unregister_device(user, token = nil)
    user.device.destroy if user.device
    Device.destroy_all(:token => token) if token
  end

end