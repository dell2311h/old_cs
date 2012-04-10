class Remote::TwitterUser
  include RemoteUser

  def friends
    friends_ids = Twitter.friend_ids(self.uid).ids
    Twitter.users(friends_ids).map do |friend|
      { uid: friend.id, name: friend.name, avatar_url: friend.profile_image_url }
    end
  end

end

