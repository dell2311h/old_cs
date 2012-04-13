object @user
attributes :id, :name, :email, :username, :phone, :dob, :website, :bio, :uploaded_videos_count, :liked_videos_count, :followings_count, :followers_count
node(:avatar_url) { |user| user.avatar.url(:thumb) if user.avatar.file? }
node(:token) { @token } if @token

if @user and @user.id == current_user.id
  child :authentications => :authentications do
    attributes :provider, :uid, :token
  end
end

unless @followed_users.nil?
  node(:followed) { |user| (@followed_users.include? user.id)? true: false }
end

