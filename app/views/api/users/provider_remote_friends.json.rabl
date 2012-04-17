object false

if @users
  node(:count) { @users.count }
end

node :users do
  @users.map{ |user| user.merge!(:is_invited_by_me => [true,false].sample) }
end

