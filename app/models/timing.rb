class Timing < ActiveRecord::Base

  validates :video_id, :start_time, :end_time, :version, :presence => true
  validates :video_id, :start_time, :end_time, :version, :numericality => { :only_integer => true }
 
  belongs_to :video

end