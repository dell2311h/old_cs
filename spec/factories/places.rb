# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place do
    name "MyString"
    user_id ""
    latiture 1.5
    longitude 1.5
  end
end
