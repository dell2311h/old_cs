# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :master_track do |f|
    f.association :event
    f.source { "https://s3.amazonaws.com/crowdsync-development/encoded/#{rand(1000)}/master_tracks/#{rand(1000)}/audio.mp3"}
    f.version { rand(1000) }
    f.is_ready true
    f.encoder_id { SecureRandom.uuid }
  end
end

