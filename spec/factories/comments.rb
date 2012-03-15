# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do 
  factory :comment do |f|
    f.association :user   
    f.text { Faker::Lorem.sentence }
  end
end
