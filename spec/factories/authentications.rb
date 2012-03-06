# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    user_id 1
    provider "MyString"
    uid 1
    token "MyString"
  end
end
