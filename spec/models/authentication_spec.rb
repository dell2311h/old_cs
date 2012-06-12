require 'spec_helper'

describe Authentication do

  it { should respond_to :user_id }
  it { should respond_to :provider }
  it { should respond_to :uid }
  it { should respond_to :token }

  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:provider).scoped_to(:uid) }

  it { should respond_to :correct_token? }
end
