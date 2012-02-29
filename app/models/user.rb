class User < ActiveRecord::Base
  
  validates :name, :login, :email, :password, :presence => true

  validates :email, :email => true 
  
  validates :login, :password,
            :length => {:minimum => 5, :maximum => 255}
  
  validates :login, :email, :uniqueness => true
  
  validates :age, :numericality => { :only_integer => true }
  
end
