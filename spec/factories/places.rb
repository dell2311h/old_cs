# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place do |f|
    f.name { Faker::Lorem.word.capitalize }
    f.association :user
    f.latitude { Faker::Geolocation.lat }
    f.longitude { Faker::Geolocation.lng }
    f.address { "#{Faker::AddressUS.state_abbr}, #{Faker::AddressUS.city}" }
  end
end

