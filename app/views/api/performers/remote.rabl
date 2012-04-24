object false

if @performers
  node(:count) { @performers.count }
end

node :performers do
  @performers.map{ |performer| performer}
end