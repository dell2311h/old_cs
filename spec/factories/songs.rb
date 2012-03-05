# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :song do |f|
    f.name Faker::Lorem.word.capitalize
  end
end
