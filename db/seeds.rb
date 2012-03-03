10.times do
  user = Factory.create :user
end

["Central Park", "Electric Chair Club", "Anfield Road", "Madison Square Garden", "Wembley Arena"].each do |name|
  Place.create name: name, latitude: Faker::Geolocation.lat, longtude: Faker::Geolocation.lng
end

