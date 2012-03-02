# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name Faker::Lorem.word.capitalize
    user_id 1
    place_id 1
  end
end


