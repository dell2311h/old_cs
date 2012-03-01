# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name     Faker::Name.name
    email    Faker::Internet.email
    username    Faker::Lorem.words(1)
    phone    Faker::PhoneNumber
    age      20
  end
end
