class InvitationSender::EmailInvite
  include InvitationSender

  def send_invitation
    InvitationMailer.send_invitation({ email: self.invitee, code: self.code }).deliver
  end

end

