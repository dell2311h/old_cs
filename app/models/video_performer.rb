class VideoPerformer < ActiveRecord::Base
  belongs_to :video
  belongs_to :performer

  validates :performer_id, :video_id, :presence => true
  validates :performer_id, :uniqueness => { :scope => :video_id }

end

