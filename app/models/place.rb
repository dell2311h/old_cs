class Place < ActiveRecord::Base

  include Follow::Relations
  include Follow::FlagsAndCounters

  has_many :events, :dependent => :destroy
  belongs_to :user

  has_many :place_providers, :dependent => :destroy

  has_many :feed_entities, :as => :entity, :class_name => "FeedItem", :dependent => :destroy
  has_many :feed_contexts, :as => :context, :class_name => "FeedItem", :dependent => :destroy

  validates :name, :user_id, :latitude, :longitude, :presence => true

  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

  reverse_geocoded_by :latitude, :longitude

  self.per_page = Settings.paggination.per_page

  scope :with_calculated_counters, with_followers_count

end

