# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name     Faker::Name.name
    email    Faker::Internet.email
    username Faker::Internet.user_name
    password "password"
    phone    Faker::PhoneNumber.phone_number
    age      ((18..90).to_a.sample)
  end
end
