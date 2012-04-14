class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :registered_user, class_name: "User", foreign_key: "registered_user_id"

  validates :mode, :invitee, presence: true
  validates :code, uniqueness: true

  before_create do |invitation|
    invitation.code = SecureRandom.urlsafe_base64
  end

  def send_invitation
    invitation_sender = InvitationSender.create self.mode, self.invitee, self.code
    invitation_sender.send_invitation
  end

end

