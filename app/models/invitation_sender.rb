module InvitationSender

  attr_reader :mode, :invitee, :code

  def self.create mode, invitee, code
    raise "Not implemented" unless self.class == "Module" || self.name == "InvitationSender"
    send_mode_class = @send_mode_classes[mode.to_sym]
    raise "Incorrect send mode" unless send_method_class

    send_mode_class.new mode, invitee, code
  end

  def initialize(mode, invitee, code)
    raise 'mode is empty' unless mode
    raise 'invitee is empty' unless invitee
    raise 'code is empty' unless code
    @mode = mode
    @invitee = invitee
    @code = code
  end

  def send_invitation
    raise 'Not implemented'
  end

  private
    @send_mode_classes = { facebook: InvitationSender::FacebookInvite,
                           twitter:  InvitationSender::TwitterInvite,
                           email:    InvitationSender::EmailInvite
                         }

end

