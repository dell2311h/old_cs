class Performer < ActiveRecord::Base

  validates :name , :presence => true

  mount_uploader :picture, ThumbnailUploader

  has_and_belongs_to_many :events

  def self.search params

    self.first 2
  end

end