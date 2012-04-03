class Clip < ActiveRecord::Base
  TYPE_DEMUX_VIDEO = 'demux_video'
  TYPE_DEMUX_AUDIO = 'demux_audio'
  TYPE_STREAMING   = 'streaming'
  belongs_to :video

  validates :source , :encoding_id, :presence => true
  validates_presence_of :video_id
end