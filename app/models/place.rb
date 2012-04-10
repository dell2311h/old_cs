class Place < ActiveRecord::Base
  has_many :events
  belongs_to :user
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy
  
  
  has_many :taggings, as: :taggable, class_name: "Tagging", dependent: :destroy
  has_many :tags, through: :taggings
  has_many :place_providers, dependent: :destroy
  
  validates :name, :user_id, :latitude, :longitude, :presence => true
  
  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }
  
  reverse_geocoded_by :latitude, :longitude

  self.per_page = Settings.paggination.per_page

  def eventful_id
    
  nil
  end
  
end
