class InvitationSender::FacebookInvite
  include InvitationSender

  def send_invitation
    self.remote_user.post(self.invitation_message, self.invitee)
  end

end

