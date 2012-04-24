object false

if @performers
  node(:count) { @performers.count }
end  

child @performers do
  extends "api/performers/show"
end
