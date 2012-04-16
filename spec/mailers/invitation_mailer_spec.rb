require "spec_helper"

describe InvitationMailer do
  describe "send_invitation" do
    let(:mail) { InvitationMailer.send_invitation }

    it "renders the headers" do
      mail.subject.should eq("Send invitation")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
