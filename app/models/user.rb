class User < ActiveRecord::Base
<<<<<<< HEAD
  
  validates :name, :login, :email, :password, :presence => true

  validates :email, :email => true 
  
  validates :login, :password,
            :length => {:minimum => 5, :maximum => 255}
  
  validates :login, :email, :uniqueness => true
  
  validates :age, :numericality => { :only_integer => true }
  
=======
  has_many :comments
  has_many :videos
  has_many :places
  has_many :events
>>>>>>> dbd6fbfcfda7adef92300411cd1ecec3fd318803
end
