FactoryGirl.define do
  factory :clip do |f|
    f.association :video
    f.source { "encoded/#{rand(10)}/#{rand(10)}/demuxed/audio.wav" }
    f.encoding_id { SecureRandom.uuid }
    f.synced { false }
    f.clip_type { [Clip::TYPE_DEMUX_AUDIO, Clip::TYPE_DEMUX_VIDEO, Clip::TYPE_SMALL_HIGH, Clip::TYPE_BIG_HIGH].sample }
  end

  factory :clip_without_add_to_pe_callback, :class => Clip do |f|

    f.after_build { |clip| clip.class.skip_callback(:create, :after, :add_to_pluraleyes) }

    f.association :video
    f.source { "encoded/#{rand(10)}/#{rand(10)}/demuxed/audio.wav" }
    f.encoding_id { SecureRandom.uuid }
    f.synced { false }
    f.clip_type { [Clip::TYPE_DEMUX_AUDIO, Clip::TYPE_DEMUX_VIDEO, Clip::TYPE_SMALL_HIGH, Clip::TYPE_BIG_HIGH].sample }
  end

end

