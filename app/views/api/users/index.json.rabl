object false

node(:count) { @users.count }

child @users do
  extends "api/users/show"
end