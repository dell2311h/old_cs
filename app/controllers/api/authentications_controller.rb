class Api::AuthenticationsController < Api::BaseController

  def link
    @oauth = current_user.link_authentication params
    render status: :accepted, action: :show
  end

  def destroy
    current_user.unlink_authentication params[:provider]
    render status: :accepted, json: {}
  end
end