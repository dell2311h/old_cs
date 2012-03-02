class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  has_many :videos

  validates :name, :presence => true
  validates :user_id, :place_id, :presence => true
end
