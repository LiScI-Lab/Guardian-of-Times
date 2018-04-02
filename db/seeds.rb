# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.random = Random.new(42)

user = User.create email: Settings.seed.email, username: Settings.seed.username, realname: Settings.seed.realname

20.times do
  User.create email: Faker::Internet.unique.email, username: Faker::Internet.unique.user_name, realname: Faker::Name.name
end

20.times do
  name = ""
  while name.length < 5
    name = Faker::HitchhikersGuideToTheGalaxy.location
  end
  p = Project.new name: name, description: Faker::HitchhikersGuideToTheGalaxy.marvin_quote
  member = p.members.new user: user, role: [:invited, :participant, :owner].sample

  unless member.invited?
    rand(0..20).times do
      start_time = Faker::Time.between(2.days.ago, Date.today, :morning)
      progress = p.progresses.new(start: start_time, end: Faker::Time.between(start_time, Date.today, :evening))
      progress.members << member
    end
  end

  p.save!
end

tags = ["rails", "dozentron", "gildamesh", "A&D"].map{ |s| Tag.new(name: s) }
tags.each { |t| t.save! }