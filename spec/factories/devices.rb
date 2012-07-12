# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do |f|
    f.association :user
    f.token "26bef9d0 71fa7471 90061b7b d304f562 f272645f 4274ced8 cdf8c933 b75f3d4e"
  end

end

