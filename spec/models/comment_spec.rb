require 'spec_helper'

describe Comment do
  it { should respond_to :user_id }
  it { should respond_to :commentable_id }
  it { should respond_to :commentable_type }
  it { should respond_to :text }
  
  it { should belong_to :user }
  it { should belong_to :commentable }
  it { should validate_presence_of :text }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }
end
