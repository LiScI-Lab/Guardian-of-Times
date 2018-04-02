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
        start_time = Faker::Time.between(2.months.ago, Date.today, :morning)
        progress = p.progresses.new(start: start_time, end: Faker::Time.between(start_time, start_time.end_of_day, :evening))
        progress.members << member
      end
    end
  end

  p.save!
end

tags = ["rails", "dozentron", "gildamesh", "A&D"].map{ |s| Tag.new(name: s) }
tags.each { |t| t.save! }

name = "40 hours project"
description = "a project with exactly 40 work hours"
project = Project.new name: name, description: description
member = project.members.new user: user, role: :owner
monday = Date.new(2018,2,1).next_week
tuesday = monday + 1.days
wednesday = monday + 2.days
thursday = monday + 3.days
tuesdays = (1...4).map {|multiplier| tuesday+(multiplier*7)} << tuesday
wednesdays = (1...4).map {|multiplier| wednesday+(multiplier*7)} << wednesday
thursdays = (1...4).map {|multiplier| thursday+(multiplier*7)} << thursday

tuesdays.each do |tuesday|
  start_time = DateTime.new(tuesday.year,tuesday.month,tuesday.day, 8,00)
  end_time = DateTime.new(tuesday.year,tuesday.month,tuesday.day, 12,00)
  progress = project.progresses.new(start: start_time, end: end_time)
  progress.members << member

  start_time = DateTime.new(tuesday.year,tuesday.month,tuesday.day, 14,00)
  end_time = DateTime.new(tuesday.year,tuesday.month,tuesday.day, 18,00)
  progress = project.progresses.new(start: start_time, end: end_time)
  progress.members << member
end
wednesdays.each do |wednesday|
  start_time = DateTime.new(wednesday.year,wednesday.month,wednesday.day, 8,00)
  end_time = DateTime.new(wednesday.year,wednesday.month,wednesday.day, 12,00)
  progress = project.progresses.new(start: start_time, end: end_time)
  progress.members << member

  start_time = DateTime.new(wednesday.year,wednesday.month,wednesday.day, 14,00)
  end_time = DateTime.new(wednesday.year,wednesday.month,wednesday.day, 18,00)
  progress = project.progresses.new(start: start_time, end: end_time)
  progress.members << member
end

thursdays.each do |thursday|
  start_time = DateTime.new(thursday.year,thursday.month,thursday.day, 14,00)
  end_time = DateTime.new(thursday.year,thursday.month,thursday.day, 16,00)
  progress = project.progresses.new(start: start_time, end: end_time)
  progress.members << member
end
project.save!