object @user
attributes :id, :name, :email, :username, :phone, :age, :dob, :website, :bio
node(:avatar_url) { |user| user.avatar.url(:thumb) if user.avatar.file? }
node(:token) { @token } if @token

child :authentications { extends "api/authentications/show" } if me?

