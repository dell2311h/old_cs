class Invitation < ActiveRecord::Base

  belongs_to :user

  validates :mode, :invitee, :user_id, presence: true
  validates :code, uniqueness: true
  validates :invitee, uniqueness: {:scope => [:mode, :user_id]}

  before_create do |invitation|
    invitation.code = SecureRandom.urlsafe_base64
  end

  def send_invitation!
    remote_user = self.user.initiate_remote_user_by(self.mode)
    invitation_sender = InvitationSender.create self.mode, self.invitee, self.code, remote_user
    invitation_sender.send_invitation
  end

end

