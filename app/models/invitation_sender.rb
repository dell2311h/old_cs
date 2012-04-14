module InvitationSender

  attr_reader :mode, :invitee, :code, :remote_user

  def self.create mode, invitee, code
    raise "Not implemented" unless self.class == "Module" || self.name == "InvitationSender"
    send_mode_class = @send_mode_classes[mode.to_sym]
    raise "Incorrect send mode" unless send_mode_class

    send_mode_class.new mode, invitee, code, sender_uid, sender_token
  end

  def initialize(mode, invitee, code, remote_user = nil)
    raise 'mode is empty' unless mode
    raise 'invitee is empty' unless invitee
    raise 'code is empty' unless code
    @mode = mode
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
    "<p>You you have been invited to #{Settings.application.name}</p><p>Your invitation code is #{self.code}</p><p>Follow this link to register #{self.registration_url}</p>"
  end

  private
    @send_mode_classes = { facebook: InvitationSender::FacebookInvite,
                           twitter:  InvitationSender::TwitterInvite,
                           email:    InvitationSender::EmailInvite
                         }

end

