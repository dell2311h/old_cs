# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do |f|
    f.name { Faker::Lorem.word.capitalize }
    f.association :user
    f.association :place
    f.master_track_version (1..99999).to_a.sample
    f.date { Time.at(rand * Time.now.to_i).to_date }
  end
end

