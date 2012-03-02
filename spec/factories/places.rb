# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place do
    name Faker::Lorem.word.capitalize
    user_id 1
    latitude Faker::Geolocation.lat
    longitude Faker::Geolocation.lng
  end
end
