# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment_video_feed, :class => FeedItem do |f|
    f.association :user
    f.association :entity, :factory => :video
    f.association :context, :factory => :event
    f.action "comment_video"
  end
end