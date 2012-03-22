object @video

attributes :id, :name, :user_id, :event_id

node(:video_url) { |video| video.clip.url if video.clip.file? }
