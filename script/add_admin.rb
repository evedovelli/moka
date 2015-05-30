u = User.find_by_username(ARGV[0])
if u
  u.add_role(:admin)
end
