object false
node(:count) { @events.count }

child(@events, :object_root => false) do
  extends "api/events/show"
end
