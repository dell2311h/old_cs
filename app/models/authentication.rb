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

end
