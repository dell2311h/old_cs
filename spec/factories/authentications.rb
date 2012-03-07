# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do |f|
    f.association :user
    f.provider "facebook"
    f.uid (1..99999).to_a.sample
    f.token "qwerty#{(1..99999).to_a.sample}"
  end
end
