class User < ActiveRecord::Base
  
  validates :name, :username, :email, :password, :presence => true

  validates :email, :email => true 
  
  validates :username, :password,
            :length => {:minimum => 3, :maximum => 255}
  
  validates :password,
            :length => {:minimum => 6, :maximum => 255}
  
  validates :username, :email, :uniqueness => true
  
  validates :age, :numericality => { :only_integer => true }
  validates_inclusion_of :age, :in => 0..150
  
  has_many :comments
  has_many :videos
  has_many :places
  has_many :events

end
