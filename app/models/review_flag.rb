class ReviewFlag < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :user_id, :video_id, :presence => true
  validates :user_id, :uniqueness => { :scope => :video_id }

end

