class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy

  has_many :videos, through: :taggings
  has_many :comments, through: :taggings

  validates :name, presence: true

  def self.create_by_comment comment
    tags = find_tags_in comment.text
    tags.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name.downcase)
      tagging = tag.taggings.build({ :user_id    => comment.user_id,
                                     :video_id   => comment.video_id,
                                     :comment_id => comment.id })
      tagging.save
    end

  end

  private 

  def self.find_tags_in comment_text
    comment_text.scan(/#(\S*)(?:\z|\s)/).uniq.flatten
  end

end

