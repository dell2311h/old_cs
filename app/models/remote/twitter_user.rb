class Remote::TwitterUser
  include RemoteUser

  def friends
    friends_ids = Twitter.friend_ids(self.uid).ids
    Twitter.users(friends_ids).map do |friend|
      { uid: friend.id.to_s, name: friend.name, avatar_url: friend.profile_image_url }
    end
  end

  def post(message, link, target_uid)
    screen_name = Twitter.user(target_uid.to_i).screen_name
    current_user.update("@#{screen_name} #{message} #{link}")
  end

  def self.get_uid_by_token(token)
    twitter = self.create_client(token)
    user = twitter.verify_credentials

    user.id
  end

  private
    def self.process_token(token)
      oauth_token, oauth_token_secret = token.split('|')
    end

    def self.create_client(token)
      oauth_token, oauth_token_secret = self.process_token(token)
      Twitter::Client.new :consumer_key => Settings.twitter.consumer_key, :consumer_secret => Settings.twitter.consumer_secret, :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret
    end

    def current_user
      @twitter_user = self.create_client(self.token)
    end

end

