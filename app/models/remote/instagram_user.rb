require "instagram"
class Remote::InstagramUser
  include RemoteUser

  def friends
    configure
    Instagram.follows.map do |friend|
      { uid: friend.id, name: "#{friend.first_name} #{friend.last_name}", avatar_url: friend.profile_image_url }
    end
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