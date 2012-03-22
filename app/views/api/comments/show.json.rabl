object @comment
attributes :id, :text

child :user do
  attributes :id, :username, :name
  node(:avatar_url) { |user| user.avatar.url(:thumb) if user.avatar.file? }
end
