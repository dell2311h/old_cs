object false
child @event do
  extends "api/events/show"
end

node :playlist do
  { :timelines => partial("api/events/timeline", :object => @timelines) }
end

node(:master_track) { "#{Settings.encoding.storage.host}/#{@master_track.source}" }
