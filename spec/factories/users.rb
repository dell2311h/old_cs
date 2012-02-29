# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
    login "MyString"
    password "MyString"
    phone "MyString"
    age 1
    avatar "MyString"
  end
end
