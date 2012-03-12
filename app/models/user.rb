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

  has_many :comments, :dependent => :destroy
  has_many :videos
  has_many :places
  has_many :events
  has_many :authentications, :dependent => :destroy

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  accepts_nested_attributes_for :authentications

  before_create :reset_authentication_token

end
