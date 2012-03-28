class Clip < ActiveRecord::Base
  TYPE_DEMUX_VIDEO = 'demux_video'
  TYPE_DEMUX_AUDIO = 'demux_audio'
  belongs_to :video
end