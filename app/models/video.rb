class Video < ActiveRecord::Base
  attr_accessible :clip, :event_id, :user_id, :name
  has_attached_file :clip

  validates :user_id , :event_id, :name, :presence => true
  validates :user_id, :event_id, :numericality => { :only_integer => true }

  validates_attachment_presence :clip
  validates_attachment_content_type :clip, :content_type => ['video/mp4']

  belongs_to :event
  belongs_to :user
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy
    
  has_many :taggings, as: :taggable, class_name: "Tagging", dependent: :destroy
  has_many :tags, through: :taggings
  
  has_many :video_songs, dependent: :destroy
  has_many :songs, through: :video_songs

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => self.name,
      "size" => self.clip.size,
      "url" => self.clip.url,
      "thumbnail_url" => "",
      "delete_url" => "/videos/#{self.id}",
      "delete_type" => "DELETE"
    }
  end

end

