class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  has_many :videos

  validates :name, :presence => true
  validates :user_id, :place_id, :presence => true
  
  def api_data
    hash = self.attributes
    hash.delete("created_at")
    hash.delete("updated_at")
    hash
  end
end
