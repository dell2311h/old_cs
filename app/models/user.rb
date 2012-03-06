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

  has_many :comments
  has_many :videos
  has_many :places
  has_many :events
  has_many :authentications, :dependent => :destroy

  accepts_nested_attributes_for :authentications

  before_save :reset_authentication_token

protected

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    where(["username = :login OR email = :login",
           {:login => login}])
    .first
  end

end
