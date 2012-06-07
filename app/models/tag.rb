class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy

  has_many :events, through: :taggings, source: :taggable, source_type: "Event"
  has_many :places, through: :taggings, source: :taggable, source_type: "Place"
  has_many :videos, through: :taggings, source: :taggable, source_type: "Video"

  validates :name, presence: true

  def self.find_taggable_by(user = nil, params)
    class_name = case params[:taggable]
      when /videos|places|events/
        params[:taggable][0..-2]
    end

    model_class = class_name.capitalize.constantize

    if user and (model_class == Video) and (unscoped_instance = model_class.unscoped.find(params[:id])).user_id == user.id
      unscoped_instance
    else
      model_class.find(params[:id])
    end
  end

  def self.add_for(taggable, tags)
    tags.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name.downcase)
      taggable.tags << tag if !taggable.tags.find_by_id(tag)
    end
    taggable.tags.map(&:name)
  end


end

