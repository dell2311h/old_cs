class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uniqueness => {:scope => :uid}
  validates :provider, :uniqueness => {:scope => :user_id}
  validates :provider, :uid, :user_id, presence: true

  scope :provider, lambda {|provider| where("provider =  ?", provider) }

  def correct_token?(token)
    # TODO: Need add verification of token
    true
  end
  
  def remote_friends
    users = RemoteUser.create self.provider, self.uid, self.token
    friends = users.friends

    ids = []
    friends.each do |friend|
      ids.push friend["id"]
    end

    User.find_by_remote_provider self.provider, ids
  end

end
