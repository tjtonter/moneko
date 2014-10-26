# ruby encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


u = User.create!({name: "Timo Tonteri", password: "eisalasana", password_confirmation:"eisalasana", email: "timo.tonteri@helsinki.fi", username: "timo"})
u.roles = ["admin", "user"]
