class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uniqueness => {:scope => :uid}

  def correct_token?(token)
    # TODO: Need add verification of token
    true
  end

end
