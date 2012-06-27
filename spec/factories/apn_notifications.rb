# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :apn_notification do |f|
    f.association :user
    f.association :feed_item, :factory => :comment_video_feed
    f.creation_date { Time.now + (0..7).to_a.sample.days }
  end
end
