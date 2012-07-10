class Device < ActiveRecord::Base
  belongs_to :user
  validates_format_of :token, :with => /^[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}$/, :allow_nil => true

  def self.register_device(user, token)
    Device.unregister_device user
    Device.create({:user => user, token => token})
  end

  def self.unregister_device(user)
    User.device.destroy if User.device
  end

end