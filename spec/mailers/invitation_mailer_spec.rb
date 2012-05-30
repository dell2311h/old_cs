require "spec_helper"

describe InvitationMailer do
  describe "send_invitation" do
    let(:invitation_hash) { { :email => Faker::Internet.email, :code => SecureRandom.uuid } }
    let(:mail) { InvitationMailer.send_invitation(invitation_hash)  }

    it "renders the headers" do
      mail.subject.should eq("Invite to #{Settings.application.name}")
      mail.to.should eq([invitation_hash[:email]])
      mail.from.should eq([Settings.mailers.email.noreply])
    end

    it "renders the body" do
      mail.body.encoded.should match("#{invitation_hash[:code]}")
    end
  end

end

