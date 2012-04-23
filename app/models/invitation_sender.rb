module InvitationSender

  attr_reader :invitee, :code, :remote_user

  def self.create mode, invitee, code, remote_user
    raise "Not implemented" unless self.class == "Module" || self.name == "InvitationSender"
    send_mode_class = @send_mode_classes[mode.to_sym]
    raise "Incorrect send mode" unless send_mode_class

    send_mode_class.new invitee, code, remote_user
  end

  def initialize(invitee, code, remote_user = nil)
    raise 'invitee is empty' unless invitee
    raise 'code is empty' unless code
    @invitee = invitee
    @code = code
    @remote_user = remote_user if remote_user
  end

  def send_invitation
    raise 'Not implemented'
  end

  def registration_url
    "#{Settings.application.host}/sign_up?invite_code=#{self.code}"
  end

  def invitation_message
    "You you have been invited to #{Settings.application.name}."
  end

  private
    @send_mode_classes = { facebook:  InvitationSender::FacebookInvite,
                           twitter:   InvitationSender::TwitterInvite,
                           email:     InvitationSender::EmailInvite,
                           instagram: InvitationSender::Instagram
                         }

end
