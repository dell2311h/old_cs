class Video < ActiveRecord::Base
  attr_accessible :clip, :event_id, :user_id, :name
  has_attached_file :clip
  
  belongs_to :event
end
