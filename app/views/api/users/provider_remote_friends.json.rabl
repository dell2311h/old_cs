object false

if @users
  node(:count) { @users.count }
end

node :users do
  @users.map{ |user| user}
end