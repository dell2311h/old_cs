# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do |f|
    f.association :user
    f.association :video
    f.text { Faker::Lorem.sentence }
  end

  factory :comment_without_callbacks, :parent => :comment do |f|
    f.after_build { |comment| comment.class.skip_callback(:create, :after, :accure_achievement_points) }
    f.after_build { |comment| comment.class.skip_callback(:create, :after, :create_tags) }
  end

end

