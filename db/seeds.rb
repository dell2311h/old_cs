10.times do
  user = Factory.create :user
end


places = ["Central Park", "Electric Chair Club", "Anfield Road", "Madison Square Garden", "Wembley Arena"].collect do |name|
  Place.create name: name, latitude: Faker::Geolocation.lat, longtude: Faker::Geolocation.lng
end

p places

#Event.create([{:name=> "Djent Fest", :place_id => 1, :user_id => 1}, {:name=> "Apocalypse", :place_id => 1, :user_id => 1}, {:name=> "Death Metal Charity Concert", :place_id => 1, :user_id => 1}])
#Video.create([{:user_id => 1, :name => "Andy Hauck's guitar solo", :event_id => 1}, {:user_id => 1, :name => "Vildhjarta - All These Feelings", :event_id => 1}, {:user_id => 1, :name => "Meteoroids Fall", :event_id => 2}])
