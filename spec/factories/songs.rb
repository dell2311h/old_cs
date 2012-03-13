# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :song do |f|
    f.name { Faker::Lorem.word.capitalize }
    f.after_create {|song| Factory(:video_song, :song => song) }
  end
end

