# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :apn_notification do |f|
    f.association :user
    f.sound true
    f.alert { Faker::Lorem.sentence }
    f.badge { (1..10).to_a.sample }
    f.sent_at nil
  end
end
