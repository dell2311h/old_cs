class Api::AuthenticationsController < Api::BaseController

  def link
    @oauth = current_user.link_authentication params
    render status: :ok, action: :show
  end

  def destroy
    current_user.unlink_authentication params[:provider]
    render status: :ok, json: {}
  end

  def remote_firends
    remote_provider = current_user.authentications.provider params['provider']
    @users = remote_provider.first.remote_friends
    if @users.count < 1
      render :status => :not_found, json: {}
      return
    end
    render status: :ok, :template => "api/users/index"
  end
end