# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do |f|
    f.after_build { |event| event.class.skip_callback(:create, :after, :create_pluraleyes_project) }
    f.name { Faker::Lorem.word.capitalize }
    f.association :user
    f.association :place
    f.master_track_version (1..99999).to_a.sample
    f.date { Time.at(rand * Time.now.to_i).to_date }
  end

  factory :event_with_add_to_pe_callback, :class => Event do |f|
    f.name { Faker::Lorem.word.capitalize }
    f.association :user
    f.association :place
    f.master_track_version (1..99999).to_a.sample
    f.date { Time.at(rand * Time.now.to_i).to_date }
  end

  factory :event_with_ready_master_track, :parent => :event do |f|
    after_create do |event|
      FactoryGirl.create(:master_track, :event => event, :version => event.master_track_version, :is_ready => true)
    end
  end

  factory :event_with_not_ready_master_track, :parent => :event do |f|
    after_create do |event|
      FactoryGirl.create(:master_track, :event => event, :version => event.master_track_version, :is_ready => false)
    end
  end
end
