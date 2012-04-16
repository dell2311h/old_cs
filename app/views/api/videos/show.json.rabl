object @video

attributes :id, :user_id, :event_id, :uuid, :last_chunk_id, :status

node(:video_url) { |video| video.clip.url if video.clip.file? }

child :event => :event do
  attributes :id, :name
end

child :user => :user do
  attributes :id, :name
end

attribute :created_at => :date

unless @likes_count.nil?
  node(:likes_count) { |video| (@likes_count[video.id].nil?)? 0: @likes_count[video.id] }
end

unless @comments_count.nil?
  node(:comments_count) { |video| (@comments_count[video.id].nil?)? 0: @comments_count[video.id] }
end

node(:duration) { 55 }

node(:video_url) { |video| video.clip.url if video.clip.file? }

node(:uploaded_file_size) { |video| video.tmpfile_size }

