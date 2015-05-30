u = User.create!({
  username: "admin",
  email: "admin@admin.com",
  password: "adminadmin",
  password_confirmation: "adminadmin"
})
u.add_role(:admin)
b1 = Stuff.create!({
  name: "Joana",
  picture: 1
})
b2 = Stuff.create!({
  name: "João",
  picture: 2
})
b3 = Stuff.create!({
  name: "Jaime",
  picture: 3
})
b4 = Stuff.create!({
  name: "Janete",
  picture: 4
})
Contest.create!({
  stuff_ids: [b1.id, b2.id, b4.id],
  starts_at: DateTime.now,
  finishes_at: DateTime.now + 2.days
})

