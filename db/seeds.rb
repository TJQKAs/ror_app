# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# User
User.create!(
 name: "JohnnyBee",
 nickname: "Blink182",
 email: "example@gambler.com",
 password: "holahola",
 password_confirmation: "holahola",
 admin: true,
 activated: true,
 activated_at: Time.zone.now )

399.times do |n|
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

# Microposts
users = User.order(:created_at).take(6)
75.times do
  content = Faker::Lorem.sentence(5)
  users.each  {|user| user.microposts.create!(content: content)}
end

# Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each {|followed| user.follow(followed)}
followers.each {|follower| follower.follow(user)}
