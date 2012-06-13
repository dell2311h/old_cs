# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feed_item do
    action "MyString"
    user_id 1
    itemable_type "MyString"
    itemable_id ""
    contextable_id 1
    contextable_type "MyString"
  end
end
