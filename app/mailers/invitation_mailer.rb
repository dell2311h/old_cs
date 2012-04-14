class InvitationMailer < ActionMailer::Base
  default from: Settings.mailers.email.noreply

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.send_invitation.subject
  #
  def send_invitation(invitation_hash)
    @email = invitation_hash[:email]
    @code = invitation_hash[:code]
    mail(:to => @email, :subject => "Invite to #{Settings.application.name}")
  end
end

