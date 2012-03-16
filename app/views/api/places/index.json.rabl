object false

if @places
  node(:count) { @places.count }
end

child @places do
  extends "api/places/show"
end
