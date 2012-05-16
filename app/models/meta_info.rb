class MetaInfo < ActiveRecord::Base
  belongs_to :video

  validates :recorded_at, presence: true

end

