module RemoteUser

  attr_reader :uid, :token

  def self.create provider, uid, token
    raise "Not implemented" unless self.class == "Module" || self.name == "RemoteUser"
    provider_class = @provider_classes[provider.to_sym]
    raise "Bad provider" if provider_class.nil?

    provider_class.new uid, token
  end

  def initialize(uid, token = nil)
    raise 'uid not set' if uid.nil?
    @uid   = uid
    @token = token
  end

  def post(message, link, target_uid)
    raise 'Not implemented'
  end

  def friends
    raise 'Not implemented'
  end

  private
    @provider_classes = { facebook:   Remote::FacebookUser,
                          twitter:    Remote::TwitterUser,
                          foursquare: Remote::FoursquareUser,
                          instagram:  Remote::InstagramUser
                     }

end

