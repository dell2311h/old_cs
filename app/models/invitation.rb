class Invitation < ActiveRecord::Base

  belongs_to :user
  belongs_to :registered_user, class_name: "User", foreign_key: "registered_user_id"

  validates :mode, :invitee, presence: true
  validates :code, uniqueness: true

  before_create do |invitation|
    invitation.code = SecureRandom.urlsafe_base64
  end

  def send_invitation!
    remote_user = self.user.initiate_remote_user_by(self.mode)
    invitation_sender = InvitationSender.create self.mode, self.invitee, self.code, remote_user
    invitation_sender.send_invitation
  end

end

