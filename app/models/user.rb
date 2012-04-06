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

  validates :latitude, :longitude, :numericality => true

  has_many :comments, :dependent => :destroy
  has_many :videos
  has_many :places
  has_many :events
  has_many :authentications, :dependent => :destroy

  has_attached_file :avatar, :styles => { :medium => "300x300>", :iphone => "200x200>", :thumb => "100x100>" }

  accepts_nested_attributes_for :authentications

  before_create :reset_authentication_token

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
end
