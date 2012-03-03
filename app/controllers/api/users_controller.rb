class Api::UsersController < Api::BaseController
  def create
    @user = User.new(params[:user])
    @status = 400
    @status = 201 if @user.save
    respond_with({ user: @user.to_json, errors: @user.errors.full_messages }, :status => @status, :location => nil)
  end
end
