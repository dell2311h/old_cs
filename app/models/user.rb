class User < ActiveRecord::Base
  
  validates :name, :username, :email, :password, :presence => true

  validates :email, :email => true 
  
  validates :username, :password,
            :length => {:minimum => 5, :maximum => 255}
  
  validates :username, :email, :uniqueness => true
  
  validates :age, :numericality => { :only_integer => true }
  validates_inclusion_of :age, :in => 21..30
  
  has_many :comments
  has_many :videos
  has_many :places
  has_many :events

end
