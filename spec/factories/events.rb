# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name Faker::Lorem.word.capitalize
  end
end


