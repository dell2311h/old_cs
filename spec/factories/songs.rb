# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :song do |f|
    f.after_build { |song| song.class.skip_callback(:create, :after, :accure_achievement_points) }
    f.name { "#{Faker::Lorem.word.capitalize}_#{(1..99999).to_a.sample}" }
    f.association :user
  end

end

