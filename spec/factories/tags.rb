# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do |f|
    f.name Faker::Lorem.word
  end
end
