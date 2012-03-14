# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do |f|
    f.name { Faker::Lorem.word.capitalize }
    f.association :user
    f.association :place
    f.after_create {|event| Factory(:comment, :commentable => event) }
    f.after_create {|event| Factory(:tagging, :taggable => event) }
    f.image {fixture_file_upload('spec/fixtures/dark_side.jpg', 'video/mp4', :binary)}
  end
end

