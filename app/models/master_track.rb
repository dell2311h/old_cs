class MasterTrack < ActiveRecord::Base
  belongs_to :event

  validates :event_id, :source, :version, presence: true

end

