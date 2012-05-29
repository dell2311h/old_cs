# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do |f|
    f.association :video
    f.association :user
  end
end
