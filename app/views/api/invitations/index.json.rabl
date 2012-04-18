object false

node(:count) { @invitations.count }

child @invitations do
  extends "api/invitations/show"
end