object false

if @users
  node(:count) { @users.count }
end

node :users do
  @users
end
