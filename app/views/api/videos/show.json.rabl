object @video

attributes :id, :user_id, :event_id, :uuid, :last_chunk_id, :status, :likes_count, :comments_count

node(:video_url) { |video| video.clip.url if video.clip? }

child :event => :event do
  attributes :id, :name
end

child :user => :user do
  attributes :id, :name
end

attribute :created_at => :date

node(:duration) { 55 }

node(:uploaded_file_size) { |video| video.tmpfile_size }

