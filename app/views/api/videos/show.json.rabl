object @video

attributes :id, :user_id, :event_id, :uuid, :last_chunk_id, :status

node(:video_url) { |video| video.clip.url if video.clip.file? }

node(:uploaded_file_size) { |video| video.tmpfile_size }

