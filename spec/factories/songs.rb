# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :song do |f|
    f.name { "#{Faker::Lorem.word.capitalize}_#{(1..99999).to_a.sample}" }
    f.association :user
    f.after_create {|song| Factory(:video_song, :song => song) }
  end
end

