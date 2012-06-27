# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.sex { ['m', 'f'].sample }
    f.sequence(:username) { |n| "username_#{n}_#{(1..99999).to_a.sample}" }
    f.sequence(:email) { |n| "username_#{n}_#{(1..99999).to_a.sample}@gmail.com" }
    f.password    "passwordddd"
    f.phone { Faker::PhoneNumber.phone_number }
    f.avatar {fixture_file_upload('spec/fixtures/dark_side.jpg', 'image/jpeg', :binary)}
    f.latitude { Faker::Geolocation.lat }
    f.longitude { Faker::Geolocation.lng }
    f.dob { Time.at(rand * Time.now.to_i).to_date }
    f.website { Faker::Internet.domain_name }
    f.bio { Faker::Lorem.sentence }
    f.email_notification_status { ["none", "immediate", "day", "week"].to_a.sample }
    f.achievement_points_sum { rand(100) }
  end

  factory :social_user, :parent => :user do |f|
    f.authentications {|auth| [auth.association(:authentication)]}
  end
end
