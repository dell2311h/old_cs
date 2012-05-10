object false
child @event do
  extends "api/events/show"
end

node :playlist do
  { :timelines => partial("api/events/timeline", :object => @timelines) }
end