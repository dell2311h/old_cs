# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    user_id 1
    registered_user_id 1
    is_used false
    method "MyString"
    invitee "MyString"
    code "MyString"
  end
end
