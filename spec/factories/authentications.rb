# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do |f|
    f.association :user
    f.provider "facebook"
    f.uid {rand(9999)}
    f.token "qwerty#{rand(9999)}"
  end
end
