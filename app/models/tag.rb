class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  
  has_many :events, through: :taggings, source: :taggable, source_type: "Event"
  has_many :places, through: :taggings, source: :taggable, source_type: "Place"
  has_many :videos, through: :taggings, source: :taggable, source_type: "Video"
  
  validates :name, presence: true
end
