# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :video do |f|
    f.association :user
    f.association :event
    f.uuid { SecureRandom.uuid }
    f.status { Video::STATUS_PROCESSING_DONE }
    f.clip {fixture_file_upload('spec/fixtures/clip.mp4', 'video/mp4', :binary)}
    f.after_create {|video| Factory(:tagging, :taggable => video) }
  end
end
