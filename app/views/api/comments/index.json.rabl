object false

if @comments
  node(:count) { @comments.count }
end

child @comments do
  extends "api/comments/show"
end
