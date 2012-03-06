class Video < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy
end
