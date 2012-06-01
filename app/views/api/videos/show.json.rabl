object @video

attributes :id, :user_id, :event_id, :uuid, :last_chunk_id, :status, :likes_count, :comments_count

node(:video_url) { |video| video.clip.url if video.clip? }

child :cached_event => :event do
  attributes :id, :name
end

child :cached_user => :user do
  attributes :id, :first_name, :last_name, :username
  node(:avatar_url) { |user| user.avatar.thumb.url if user.avatar? }
end

attribute :created_at => :date

node(:duration) { 55 }

node(:uploaded_file_size) { |video| video.tmpfile_size }

if current_user
  node(:liked_by_me) { |video| video.respond_to?(:liked_by_me) && (video.liked_by_me == 1) ? true : false }
end

