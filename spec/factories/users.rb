# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |f|
    f.name     Faker::Name.name
    f.username    Faker::Internet.user_name
    f.email    Faker::Internet.email
    f.password    "passwordddd"
    f.phone    Faker::PhoneNumber.phone_number
    f.age      20
  end
end
