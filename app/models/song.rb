class Song < ActiveRecord::Base
  has_many :comments, :as => :commentable, :class_name => "Comment", :dependent => :destroy
end
