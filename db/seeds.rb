10.times do
  user = Factory.create :user
end


["Central Park", "Electric Chair Club", "Anfield Road", "Madison Square Garden", "Wembley Arena"].collect do |name|
  Place.create name: name, latitude: Faker::Geolocation.lat, longitude: Faker::Geolocation.lng
end

["Djent Fest", "Technical Metal Fest", "Brutal Death Metal Charity Concert", "Apocalypse"].collect do |name|
  Factory.create :event, name: name
end

3.times { Factory.create :video }
