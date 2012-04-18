class Api::InvitationsController < Api::BaseController

  def index
    @invitations = current_user.invitations
    @invitations = @invitations.where(:mode => params[:mode]) if params[:mode]
  end

  def create
    current_user.send_invitation_by! params[:invitation]
    render status: :ok, json: {}
  end

end
