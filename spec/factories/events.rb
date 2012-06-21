# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do |f|
    f.name { Faker::Lorem.word.capitalize }
    f.association :user
    f.association :place
    f.master_track_version (1..99999).to_a.sample
    f.date { Time.at(rand * Time.now.to_i).to_date }
  end

  factory :event_without_add_to_pe_callback, :class => Event do |f|

    f.after_build { |event| event.class.skip_callback(:create, :after, :create_pluraleyes_project) }

    f.name { Faker::Lorem.word.capitalize }
    f.association :user
    f.association :place
    f.master_track_version (1..99999).to_a.sample
    f.date { Time.at(rand * Time.now.to_i).to_date }
  end
end

