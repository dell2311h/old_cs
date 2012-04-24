class Performer < ActiveRecord::Base

  validates :name , :presence => true

  mount_uploader :picture, ThumbnailUploader

  has_and_belongs_to_many :events

  def self.search params
    performers = self
    unless params[:performer_name].nil?
      performers = performers.where("UPPER(name) LIKE ?", "%#{params[:performer_name].to_s.upcase}%")
    end

    performers
  end

end