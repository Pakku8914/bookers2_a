# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: "asdf", email: "b@b", password: "bbbbbb")
User.create(name: "fghfgkh", email: "c@c", password: "cccccc")
User.create(name: "qwer", email: "d@d", password: "dddddd")

10.times do |num|
	Book.create(title: num, body: num, user_id: num%3)
end