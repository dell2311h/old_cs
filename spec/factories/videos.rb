# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do |f|
    f.association :user
    f.association :event
    f.name Faker::Lorem.word.capitalize
  end
end
