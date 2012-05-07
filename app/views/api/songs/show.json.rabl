object @song
attributes :id, :name, :videos_count

node(:comments_count) { |song| song.comments_count.to_i if song.respond_to?(:comments_count) }

node(:most_popular_video_id) { |song| song.most_popular_video.id if song.most_popular_video }

