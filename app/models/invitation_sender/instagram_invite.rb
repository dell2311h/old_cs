class InvitationSender::InstagramInvite
  include InvitationSender

  def send_invitation
    self.remote_user.post(self.invitation_message, self.registration_url, self.invitee)
  end

  def invitation_message
    "have been invited to #{Settings.application.name}"
  end

end
