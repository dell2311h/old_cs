object false

node(:count) { @videos.count }

child @videos do
  extends "api/videos/show"
end
