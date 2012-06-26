class Api::UserSessionsController < Api::BaseController

  skip_before_filter :auth_check, :only => [:create]

  def create
    @user = User.authorize_by params
    sign_in @user if @user

    render status: :ok, json: { token: @token }
  end

end
