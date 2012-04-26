object false

if @events[:size]
  node(:count) { @events[:size] }


  node :events do
    @events[:events].map{ |event| event}
  end
end