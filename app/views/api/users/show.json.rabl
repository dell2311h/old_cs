object @user
attributes :id, :name, :email, :username, :phone, :age
node(:avatar_url) { |user| user.avatar.url(:thumb) if user.avatar.file? }
node(:token) { @token } if @token

