module Follow::Relations

  def self.included(base)
    base.has_many :relationships, :as => :followable, :class_name => "Relationship", :dependent => :destroy
    base.has_many :followers, :through => :relationships, :source => :follower
  end

end

