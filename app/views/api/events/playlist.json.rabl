object false
child @event do
  extends "api/events/show"
end

node :playlist do
  { :timelines => partial("api/events/timeline", :object => @timelines) }
end

node(:master_track) { @master_track.source }
