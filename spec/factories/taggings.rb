# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging do |f|
    f.association :user
    f.association :tag
  end
end
