class PlaceProvider < ActiveRecord::Base
  belongs_to :place

  validates :place_id, :remote_id, :provider, presence: true
end