attributes :followers_count

if current_user
  node(:followed) { |user| user.respond_to?(:followed) && (user.followed == 1) ? true : false }
end

