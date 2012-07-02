class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uniqueness => {:scope => :uid}
  validates :provider, :uniqueness => {:scope => :user_id}
  validates :provider, :uid, :user_id, :presence => true

  scope :provider, lambda {|provider| where("provider =  ?", provider) }

  def self.not_on_remote_provider remote_users, provider
        uids = remote_users.map { |remote_user| remote_user[:uid] }
        local_users = Authentication.provider(provider).where("uid IN (?)", uids).select("uid")
        local_users.map do |local_user|
          remote_users.delete_if {|user| user[:uid] == local_user.uid.to_s }
        end
        remote_users
  end

  def correct_token?(token)
    # TODO: Need add verification of token
    !token.empty?
  end

end

