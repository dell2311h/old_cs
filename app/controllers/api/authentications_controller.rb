class Api::AuthenticationsController < Api::BaseController

  def link
    @oauth = current_user.link_authentication params
    render status: :ok, action: :show
  end

  def destroy
    current_user.unlink_authentication params[:provider]
    render status: :ok, json: {}
  end
end