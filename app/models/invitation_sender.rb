module InvitationSender

  attr_reader :method, :invitee, :code

  def self.create method, invitee, code
    raise "Not implemented" unless self.class == "Module" || self.name == "InvitationSender"
    send_method_class = @send_method_classes[method.to_sym]
    raise "Incorrect send method" unless send_method_class

    send_method_class.new method, invitee, code
  end

  def initialize(method, invitee, code)
    raise 'method is empty' unless method
    raise 'invitee is empty' unless invitee
    raise 'code is empty' unless code
    @method = method
    @invitee = invitee
    @code = code
  end

  private
    @send_method_classes = { facebook: InvitationSender::FacebookInvite,
                             twitter:  InvitationSender::TwitterInvite,
                             email:    InvitationSender::EmailInvite
                           }

end

