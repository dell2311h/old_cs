# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timing do |f|
    f.association :video
    random_time = (1..99999).to_a.sample
    f.start_time random_time
    f.end_time (random_time + (1..99999).to_a.sample)
    f.version (1..9999).to_a.sample
  end
end
