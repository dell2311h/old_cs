# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do |f|
    f.name { Faker::Lorem.word.capitalize }
    f.association :user
    f.association :place
    f.date { Time.at(rand * Time.now.to_i).to_date }
    f.after_create {|event| Factory(:comment, :commentable => event) }
    f.after_create {|event| Factory(:tagging, :taggable => event) }
  end
end

