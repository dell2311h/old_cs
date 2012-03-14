collection @events
extends "api/events/show"
node(:count) { @events.count }
