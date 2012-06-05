class Relationship < ActiveRecord::Base

  attr_accessible :followable_id, :followable_type

  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"

  validates :follower_id, :followed_id, presence: true
  validates :follower_id, :uniqueness => {:scope => :followed_id}

  validate :no_self_following

  private

    def no_self_following
      errors.add("can't be the current user!") if (self.follower_id == self.followable_id) && (self.followable_type == "User")
    end

end

