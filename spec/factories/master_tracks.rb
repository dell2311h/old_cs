# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :master_track do
    event_id 1
    source "MyString"
    version 1
    is_ready false
  end
end
