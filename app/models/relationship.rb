class Relationship < ActiveRecord::Base

  attr_accessible :followable

  belongs_to :follower, :class_name => "User"

  belongs_to :followable, :polymorphic => true

  validates :follower_id, :followable_id, :followable_type, :presence => true
  validates :follower_id, :uniqueness => {:scope => [:followable_id, :followable_type]}

  validate :no_self_following

  private

    def no_self_following
      errors.add(:base, "can't be the current user!") if (self.follower_id == self.followable_id) && (self.followable_type == "User")
    end

end

