object false

if @songs
  node(:count) { @songs.count }
end  

child @songs do
  extends "api/songs/show"
end
