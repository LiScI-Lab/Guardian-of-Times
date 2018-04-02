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

  name = ""
  while name.length < 5
    name = Faker::HitchhikersGuideToTheGalaxy.location
  end
  p = Project.create name: name, description: Faker::HitchhikersGuideToTheGalaxy.marvin_quote
end


Project.all.each do |p|
  p.members.create user: user, role: [:participant, :owner].sample, status: [:joined, :leaved, :invited].sample

  rand(0..5).times do
    m = p.members.find_or_initialize_by user_id: rand(2..19)
    m.role = :participant
    m.status = [:joined, :leaved, :invited].sample
    m.save!
  end

  p.save!

  p.members.each do |member|
    if member.target_hours.empty?
      member.target_hours.new hours: rand(20..45), since: DateTime.now.to_date.beginning_of_month
    end

    unless member.invited?
      rand(0..20).times do
        start_time = Faker::Time.between(2.days.ago, Date.today, :morning)
        progress = p.progresses.new(start: start_time, end: Faker::Time.between(start_time, Date.today, :evening))
        progress.members << member
      end
    end
  end

  p.save!
end

tags = ["rails", "dozentron", "gildamesh", "A&D"].map{ |s| Tag.new(name: s) }
tags.each { |t| t.save! }