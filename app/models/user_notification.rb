class UserNotification < ActiveRecord::Base

  belongs_to :user, :feed_item

  validate :user_id, :feed_item_id, :numericality => { :only_integer => true }
  validates :creation_date, :presence => true

end