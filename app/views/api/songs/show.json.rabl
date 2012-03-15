object @song
attributes :id, :name

node(:videos_count) { |song| song.videos.count }
