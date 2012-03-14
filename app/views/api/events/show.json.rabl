object @event
attributes :id, :name, :date

node(:image_url) { |event| event.image.url(:iphone) }

child :place do
  extends "api/places/show"
end

node(:songs_count) { |event| event.songs_count }
node(:videos_count) { |event| event.videos.count }
node(:comments_count) { |event| event.comments.count }
