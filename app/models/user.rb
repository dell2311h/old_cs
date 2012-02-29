class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable,
  # :rememberable, :trackable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable,  :validatable, :encryptable,
         :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :login, :password, :phone, :age, :avatar

  validates :name, :login, :email, :password, :presence => true

  validates :email, :email => true

  validates :login, :password,
            :length => {:minimum => 5, :maximum => 255}

  validates :login, :email, :uniqueness => true

  validates :age, :numericality => { :only_integer => true }

  has_many :comments
  has_many :videos
  has_many :places
  has_many :events

end
