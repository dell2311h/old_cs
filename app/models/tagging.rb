class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user
  belongs_to :video
  belongs_to :comment

  validates :tag_id, :video_id, :comment_id, :presence => true
end
