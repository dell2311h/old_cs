object @comment
attributes :id, :text, :created_at

child :user do
  attributes :id, :username, :first_name, :last_name
  node(:avatar_url) { |user| user.avatar.thumb.url if user.avatar? }
end

