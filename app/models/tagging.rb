class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user
  belongs_to :video

  validates :tag_id, :video_id, :presence => true
end
