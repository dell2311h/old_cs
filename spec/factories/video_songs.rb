# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video_song do |f|
    f.association :user
    f.association :song
    f.association :video
  end
end
