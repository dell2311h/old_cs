class Remote::TwitterUser
  include RemoteUser

  def friends
    friends_ids = Twitter.friend_ids(self.uid).ids
    Twitter.users(friends_ids).map do |friend|
      { uid: friend.id_str, name: friend.name, avatar_url: friend.profile_image_url }
    end
  end

  def post(message, link, target_uid)
    screen_name = Twitter.user(target_uid.to_i).screen_name
    current_user.update("@#{screen_name} #{message} #{link}")
  end

  private
    def current_user
      oauth_token, oauth_token_secret = self.token.split('|')
      @twitter_user = Twitter::Client.new :consumer_key => Settings.twitter.consumer_key, :consumer_secret => Settings.twitter.consumer_secret, :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret
    end

end

