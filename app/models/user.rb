class User < ActiveRecord::Base
  has_many :comments
  has_many :videos
  has_many :places
  has_many :events
end
