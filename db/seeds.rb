# ruby encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


customer = "Asiakas 1\nTietie 2\n00100 Helsinki"
contents = "Kaikkea ja muuta"
target = "Koti ja työpaikka, ikkunanpesut"
execution = "Nopeasti ja helposti"
delivery = "Heti hätä hätä"
charge = "Ihan liikaa"
Offer.create(customer, contents, target, execution, delivery, charge)
