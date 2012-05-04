object false
node(:count) { @events_count }

child(@events, :object_root => false) do
  extends "api/events/show"
end

