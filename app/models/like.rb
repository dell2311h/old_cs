class Like < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates :video_id, :uniqueness => { :scope => :user_id}
end
