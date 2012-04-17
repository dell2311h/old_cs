class Api::InvitationsController < Api::BaseController

  def create
    current_user.invite_by! params[:invitation]
    render status: :ok, json: {}
  end

end

