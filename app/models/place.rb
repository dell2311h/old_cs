class Place < ActiveRecord::Base
  has_many :events
  belongs_to :user
  
  validates :name, :user_id, :latitude, :longitude, :presence => true
  
  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }
  
  reverse_geocoded_by :latitude, :longitude
  
  def api_data
    hash = self.attributes
    hash.delete("created_at")
    hash.delete("updated_at")
    hash
  end  
end
