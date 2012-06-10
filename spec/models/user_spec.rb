require 'spec_helper'

describe User do

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:email) }

  it { should ensure_length_of(:username).
                is_at_least(3).
                is_at_most(255) }

  it { should ensure_length_of(:password).
                is_at_least(6).
                is_at_most(255) }

  it { should allow_value("email@gmail.com").for(:email) }
  it { should_not allow_value("email.gmail.com1").for(:email) }
  it { should_not allow_value(".gmail.com1").for(:email) }
  it { should_not allow_value("email.sddsds.").for(:email) }

  it { should have_many(:comments) }
  it { should have_many(:videos) }
  it { should have_many(:places) }
  it { should have_many(:events) }

  before(:all) do
    @user = Factory.build(:user)
  end


  describe "create method" do

    it "should be created" do
      #@user = Factory(:user)
      @user.should be_new_record
      @user.save.should be_true
      @user.should_not be_new_record
    end

  end
end
