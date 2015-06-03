u = User.create!({
  username: "admin",
  email: "admin@admin.com",
  password: "adminadmin",
  password_confirmation: "adminadmin"
})
u.add_role(:admin)
b1 = Option.create!({
  name: "Joana",
  picture: 1
})
b2 = Option.create!({
  name: "João",
  picture: 2
})
b3 = Option.create!({
  name: "Jaime",
  picture: 3
})
b4 = Option.create!({
  name: "Janete",
  picture: 4
})
Battle.create!({
  option_ids: [b1.id, b2.id, b4.id],
  starts_at: DateTime.now,
  finishes_at: DateTime.now + 2.days
})

