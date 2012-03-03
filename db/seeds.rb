# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# To avoid affection of Production DB, put all seeds into this if - end section
if ::Rails.env == "development"
  Event.create([{:name=> "Djent Fest", :place_id => 1, :user_id => 1}, {:name=> "Apocalypse", :place_id => 1, :user_id => 1}, {:name=> "Death Metal Charity Concert", :place_id => 1, :user_id => 1}])
  Video.create([{:user_id => 1, :name => "Andy Hauck's guitar solo", :event_id => 1}, {:user_id => 1, :name => "Vildhjarta - All These Feelings", :event_id => 1}, {:user_id => 1, :name => "Meteoroids Fall", :event_id => 2}])
end

