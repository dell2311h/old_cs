require 'spec_helper'

describe Api::RelationshipsController do

  let(:user) { double('current_user') }

  describe "private methods" do
    before :each do
      controller.stub!(:current_user).and_return(user)
    end
    context "#set_source_user" do
      it "should return current_user if me? (me route)" do
        controller.stub!(:me?).and_return(true)
        controller.send(:set_source_user).should be(user)
      end

      it "should return another user if not me?" do
        user_id = rand(100)
        controller.stub!(:params).and_return({:user_id => user_id})
        controller.stub!(:me?).and_return(false)
        another_user = double('another_user')
        User.should_receive(:find).with(user_id).and_return(another_user)
        controller.send(:set_source_user).should be(another_user)
      end

    end

    context "#set_status_by(collection)" do
      it "should be :ok if collection isn't empty" do
        controller.send(:set_status_by, [1]).should be(:ok)
      end

      it "should be :not_found if collection is empty" do
        controller.send(:set_status_by, []).should be(:not_found)
      end
    end

  end

end

