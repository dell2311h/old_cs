class MasterTrack < ActiveRecord::Base
  belongs_to :event

  validates :event_id, :version, presence: true
  validates :source, presence: true, :if => "is_ready == true"

  default_scope order("version DESC")

end

