class Performer < ActiveRecord::Base

  include Follow::Relations
  include Follow::FlagsAndCounters

  validates :name , :presence => true
  validates :name,  :uniqueness => true

  mount_uploader :picture, ThumbnailUploader

  has_many :video_performers, :dependent => :destroy
  has_many :videos, :through => :video_performers

  self.per_page = Settings.paggination.per_page

  def self.search params
    performers = self
    unless params[:performer_name].nil?
      performers = performers.where("UPPER(name) LIKE ?", "%#{params[:performer_name].to_s.upcase}%")
    end

    performers
  end

  scope :with_calculated_counters, with_followers_count

end

