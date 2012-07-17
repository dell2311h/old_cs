require "instagram"
class Remote::InstagramUser
  include RemoteUser

  def friends
    configure
    Instagram.user_follows.map do |friend|
      { uid: friend.id, name: friend.full_name, avatar_url: friend.profile_picture }
    end
  end

  def post(message, link, target_uid)
    medias = Instagram.user_recent_media(target_uid)
    Instagram.create_media_comment(medias.first.id, "#{message} http://#{link}") if medias.first
  end

  def self.get_uid_by_token(token)
    client = Instagram.client(:access_token => token)
    user = client.user

    user.id
  end

  private
  def configure
    Instagram.configure do |config|
      config.client_id = Settings.instagram.client_id
      config.client_secret = Settings.instagram.client_secret
      config.access_token = @token
    end
  end

end
