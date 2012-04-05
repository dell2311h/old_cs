object false

if @places
  node(:count) { @places.count }
end

node :places do
  @places.map{ |place| place}
end