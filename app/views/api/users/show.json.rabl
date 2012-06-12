object @user
attributes :id, :first_name, :last_name, :email, :username, :phone, :dob, :website, :bio, :uploaded_videos_count, :liked_videos_count, :followings_count, :email_notification_status, :sex, :points
node(:avatar_url) { |user| user.avatar.thumb.url if user.avatar? }
node(:token) { @token } if @token

if @user and current_user and @user.id == current_user.id
  child :authentications => :authentications do
    attributes :provider, :uid, :token
  end
end

extends 'api/shared/followable'

