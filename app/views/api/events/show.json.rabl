object @event
attributes :id, :name, :date, :user_id

child :place do
  extends "api/places/show"
end

node(:songs_count) { |event| event.songs.count }
node(:videos_count) { |event| event.videos.count }
node(:comments_count) { |event| event.comments_count.to_i if event.respond_to?(:comments_count) }

node(:most_popular_video_id) { |event| event.most_popular_video.id if event.most_popular_video }

extends 'api/shared/followable'

