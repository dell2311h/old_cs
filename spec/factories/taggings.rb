# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging do
    user_id 1
    tag_id 1
    taggable_id 1
    taggable_type "MyString"
  end
end
