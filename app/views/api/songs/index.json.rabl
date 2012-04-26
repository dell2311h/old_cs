object false

if @songs
  node(:count) { @songs_count }
end

child @songs do
  extends "api/songs/show"
end

