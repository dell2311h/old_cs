object false

if @comments
  node(:count) { @comments.count }
end

child @comments => :comments do
  extends "api/comments/show"
end

