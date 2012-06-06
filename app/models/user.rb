class User < ActiveRecord::Base

  attr_protected :points

  # Include default devise modules. Others available are:
  # :confirmable, :lockable,
  # :rememberable, :trackable, :timeoutable and :omniauthable


  # Setup accessible (or protected) attributes for your model
  devise :database_authenticatable, :registerable,
         :recoverable,  :validatable, :encryptable,
         :token_authenticatable, :omniauthable

  mount_uploader :avatar, AvatarUploader

  validates :username, :email, :presence => true
  validates :password, :presence => true, :if => lambda {|u| u.new_record? }
  validates :email, :email => true

  validates :username,
            :length => {:minimum => 3, :maximum => 255}

  validates :password,
            :length => {:minimum => 6, :maximum => 255}, :unless => lambda {|u| u.password.nil? }

  validates :username, :email, :uniqueness => true

  validates :latitude, :longitude, :numericality => true, :allow_nil => true

  validates :email_notification_status, :inclusion => ["none", "immediate", "day", "week"]
  validates :sex, :inclusion => ["m", "f"], :if => lambda {|u| u.sex }

  has_many :comments, :dependent => :destroy
  has_many :videos
  has_many :places
  has_many :events
  has_many :authentications, :dependent => :destroy
  has_many :likes
  has_many :liked_videos, :through => :likes, :source => :video

  # Following associations
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :reverse_relationships, :class_name => "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, :source => :follower

  # Invitations
  has_many :invitations

  # Review Flags
  has_many :review_flags, dependent: :destroy

  accepts_nested_attributes_for :authentications

  before_create :reset_authentication_token

  scope :by_remote_provider_ids, lambda{|provider, uids| where("authentications.provider = ? AND authentications.uid IN (?)", provider, uids).
                                                         joins(:authentications)
                                       }

  scope :with_name_like, lambda { |name| where("UPPER(CONCAT(users.first_name, ' ', users.last_name, ' ', users.username)) LIKE ?", "%#{name.to_s.upcase}%") }

  # Get all users counts by one query
  scope :with_calculated_counters, select('users.*').select("(#{Video.select("COUNT(videos.user_id)").where("users.id = videos.user_id").to_sql}) AS uploaded_videos_count, (#{Relationship.select("COUNT(relationships.follower_id)").where("users.id = relationships.follower_id").to_sql}) AS followings_count,  (#{Relationship.select("COUNT(relationships.followed_id)").where("users.id = relationships.followed_id").to_sql}) AS followers_count, (#{Like.select("COUNT(likes.user_id)").where("users.id = likes.user_id").to_sql}) AS liked_videos_count")

  scope :with_flag_followed_by, lambda { |user| select('users.*').select("(#{Relationship.select('COUNT(follower_id)').where('relationships.followed_id = users.id AND relationships.follower_id = ?', user.id).to_sql}) AS followed") }

  scope :without_user, lambda { |user| where("id <> ?", user.id) }

  self.per_page = Settings.paggination.per_page

  def self.find_followed_by user
    followed_users = Relationship.where({:follower_id => user.id})

    followed_users.map(&:followed_id)
  end

  def remote_friends_on_crowdsync_for provider
    friends = remote_friends_for provider
    uids = friends.map { |friend| friend[:uid] }
    users = User.by_remote_provider_ids provider, uids
    users = users.with_flag_followed_by(self)

    users.all
  end

  def remote_friends_not_on_crowdsync_for provider
    friends = remote_friends_for provider
    invitations = self.invitations.where(:mode => provider).map(&:invitee)
    friends.map! { |user| user.merge!(:is_invited_by_me => invitations.include?(user[:uid])) }
    Authentication.not_on_remote_provider friends, provider
  end

  def self.profile_details_by_id(user_id, current_user)
    User.with_calculated_counters.with_flag_followed_by(current_user).find user_id
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

  def self.search_by(params, current_user)
    users = User.without_user(current_user).with_flag_followed_by(current_user)
    if params[:name]
      users = users.with_name_like(params[:name])
    end

    users
  end

  def find_authentication_by_provider provider
    self.authentications.find_by_provider provider
  end

  def initiate_remote_user_by provider
    authentication = self.find_authentication_by_provider provider
    RemoteUser.create(authentication.provider, authentication.uid, authentication.token) if authentication
  end

  def create_videos_by params
    new_videos = []
    event = Event.find(params[:event_id]) if params[:event_id]
    params[:videos].each do |video_params|
      songs_params = video_params.delete(:songs)
      thumbnail_key_name = video_params.delete(:thumbnail)
      video = self.videos.build video_params
      video.status = Video::STATUS_UPLOADING
      video.event = event if event
      video.thumbnail = params[thumbnail_key_name]
      video.save!
      video.add_songs_by(songs_params) if songs_params
      new_videos << video
    end
    new_videos
  end

  def send_invitation_by! invitation_params
    mode = invitation_params[:mode]
    invitee = invitation_params[:invitee]
    invitation = self.invitations.create! :mode => mode, :invitee => invitee
    invitation.send_invitation!
  end

  private
    def remote_friends_for provider
      authenication = self.authentications.provider(provider).first
      raise 'Remote provider not found' if authenication.nil?
      user = RemoteUser.create provider, authenication.uid, authenication.token

      user.friends
    end
end

