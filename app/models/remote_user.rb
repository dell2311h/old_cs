class RemoteUser

 @provider_classes = { facebook:   RemoteUser::Facebook,
                       twitter:    RemoteUser::Twitter,
                       foursquare: RemoteUser::Foursquare,
                       instagram:  RemoteUser::Instagram
                     }

  def self.create provider, uid, token
    provider_class = @provider_classes[:provider]
    raise "Bad provider" if provider_class.nil?

    provider_class.new provider, uid, token
  end

  def initialize
    raise 'Not implemented'
  end

  def friends
    raise 'Not implemented'
  end

end
