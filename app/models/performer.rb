class Performer < ActiveRecord::Base

  validates :name , :picture, :presence => true

  mount_uploader :picture, ThumbnailUploader

  has_and_belongs_to_many :events

end