class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy

  has_many :videos, through: :taggings

  validates :name, presence: true

  def self.add_for(taggable, tags)
    tags.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name.downcase)
      taggable.tags << tag if !taggable.tags.find_by_id(tag)
    end
    taggable.tags.map(&:name)
  end


end

