# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meta_info do
    video_id 1
    recorded_at "2012-05-10 12:35:16"
    latitude 1.5
    longitude 1.5
    duration 1
  end
end
