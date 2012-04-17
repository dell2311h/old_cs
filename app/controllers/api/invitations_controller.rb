class Api::InvitationsController < Api::BaseController

  def create
    current_user.send_invitation_by! params[:invitation]
    render status: :ok, json: {}
  end

end

