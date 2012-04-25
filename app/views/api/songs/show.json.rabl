object @song
attributes :id, :name

node(:videos_count) { |song| song.videos.count }
node(:comments_count) { |song| song.comments_count }

node(:most_popular_video_id) { |song| song.most_popular_video.id if song.most_popular_video }

