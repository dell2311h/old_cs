
FactoryGirl.define do
  factory :performer do |f|
    f.name { "#{Faker::Lorem.word.capitalize}_#{(1..99999).to_a.sample}" }
    f.picture {fixture_file_upload('spec/fixtures/dark_side.jpg', 'image/jpeg', :binary)}
  end
end