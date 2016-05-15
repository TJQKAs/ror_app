# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(
 name: "JohnnyBee",
 nickname: "Blink182",
 email: "example@gambler.com",
 password: "holahola",
 password_confirmation: "holahola",
 admin: true,
 activated: true,
 activated_at: Time.zone.now )

499.times do |n|
  name = Faker::Name.name
  nickname = Faker::Name.name
  email = "example-#{n+2}@gambler.com"
  password = "holahola"
  User.create!(
   name:                                name,
   nickname:                         nickname,
   email:                               email,
   password:                         password,
   password_confirmation:  password,
   activated: true,
   activated_at: Time.zone.now )
end
