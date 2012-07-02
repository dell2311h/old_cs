class EncodingProfile < ActiveRecord::Base
  validates :name, :profile_id, :presence => true, :uniqueness => true
end

