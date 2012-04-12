object @video

attributes :id, :name

node(:video_url) { |video| video.clip.url if video.clip.file? }
child :event => :event do
  attributes :id, :name
end

child :user => :user do
  attributes :id, :name
end

attribute :created_at => :date

node(:likes_count) { 0 }
node(:comments_count) { 0 }
#node(:likes_count) { |video| video.likes_count }
