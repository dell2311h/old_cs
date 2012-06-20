class Performer < ActiveRecord::Base

  include Follow::Relations
  include Follow::FlagsAndCounters

  validates :name , :presence => true
  validates :name,  :uniqueness => true

  mount_uploader :picture, ThumbnailUploader

  has_many :video_performers, :dependent => :destroy
  has_many :videos, :through => :video_performers

  self.per_page = Settings.paggination.per_page

  scope :search, lambda { |params|
    performers = scoped
    performers = performers.joins(:video_performers).where("video_performers.video_id = ?", params[:video_id]) if params[:video_id]
    performers = performers.where("UPPER(name) LIKE ?", "%#{params[:performer_name].to_s.upcase}%") if params[:performer_name]
    performers

  }

  scope :with_calculated_counters, with_followers_count

end

