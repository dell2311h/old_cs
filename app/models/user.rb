class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable,
  # :rememberable, :trackable, :timeoutable and :omniauthable


  # Setup accessible (or protected) attributes for your model
  devise :database_authenticatable, :registerable,
         :recoverable,  :validatable, :encryptable,
         :token_authenticatable, :omniauthable

  validates :name, :username, :email, :presence => true
  validates :password, :presence => true, :if => lambda {|u| u.new_record? }
  validates :email, :email => true

  validates :username,
            :length => {:minimum => 3, :maximum => 255}

  validates :password,
            :length => {:minimum => 6, :maximum => 255}, :unless => lambda {|u| u.password.nil? }

  validates :username, :email, :uniqueness => true

  validates :age, :numericality => { :only_integer => true }
  validates_inclusion_of :age, :in => 0..150

  validates :latitude, :longitude, :numericality => true, :allow_nil => true

  has_many :comments, :dependent => :destroy
  has_many :videos
  has_many :places
  has_many :events
  has_many :authentications, :dependent => :destroy
  has_many :likes

  # Following associations
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :reverse_relationships, :class_name => "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, :source => :follower


  has_attached_file :avatar, :styles => { :medium => "300x300>", :iphone => "200x200>", :thumb => "100x100>" }

  accepts_nested_attributes_for :authentications

  before_create :reset_authentication_token

  scope :with_name_like, lambda {|name| where("UPPER(name) LIKE ?", "%#{name.to_s.upcase}%") }

  # Get all users counts by one query
  scope :with_calculated_counters, select("*, (#{Video.select("COUNT(videos.user_id)").where("users.id = videos.user_id").to_sql}) AS uploaded_videos_count, (#{Relationship.select("COUNT(relationships.follower_id)").where("users.id = relationships.follower_id").to_sql}) AS followings_count,  (#{Relationship.select("COUNT(relationships.followed_id)").where("users.id = relationships.followed_id").to_sql}) AS followers_count, (#{Like.select("COUNT(likes.user_id)").where("users.id = likes.user_id").to_sql}) AS liked_videos_count")

  def self.personal_details_by_id(user_id)
    User.with_calculated_counters.find user_id
  end

  # Followings methods
  def following?(followed)
    self.relationships.find_by_followed_id(followed.id)
  end

  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed.id).destroy
  end

  # Like methods
  def like!(video)
    self.likes.create!(:video_id => video.id)
  end

  def unlike!(video)
    like = self.likes.find_by_video_id(video.id)
    like.delete unless like.nil?
  end

  # Authentications methods
  def link_authentication oauth_params
    oauth = self.authentications.find_or_initialize_by_provider_and_uid oauth_params[:provider], oauth_params[:uid]
    oauth.update_attributes!({ :uid      => oauth_params[:uid],
                              :token    => oauth_params[:token],
                              :provider => oauth_params[:provider],
                              })

    oauth
  end

  def unlink_authentication provider
    Authentication.delete_all([ "provider = ? AND user_id = ?",provider, self.id ])
  end

  def update_coordinates coordinates
    raise "Incorrevt coordinates" if coordinates[:latitude].nil? || coordinates[:longitude].nil?
    self.update_attributes!({ :latitude  => coordinates[:latitude],
                              :longitude => coordinates[:longitude]
                              })
  end

  def self.find_users params
    users = User
    if params[:name]
      users = users.with_name_like(params[:name])
    end

    users.all
  end

end

