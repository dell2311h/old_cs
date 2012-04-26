object @song
attributes :id, :name, :videos_count, :comments_count

node(:most_popular_video_id) { |song| song.most_popular_video.id if song.most_popular_video }

