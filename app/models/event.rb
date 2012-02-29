class Event < ActiveRecord::Base

  validates :name, :presence => true
  
  def api_data
    hash = self.attributes
    hash.delete("created_at")
    hash.delete("updated_at")
    hash
  end
end
