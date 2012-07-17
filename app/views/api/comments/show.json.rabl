object @comment
attributes :id, :text

node(:created_at) { |comment| comment.created_at.to_i }

child :user do
  attributes :id, :username, :first_name, :last_name
end
