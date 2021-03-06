# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.random = Random.new(42)

unless User.find_by(email: Settings.seed.email)
  user = User.create! email: Settings.seed.email, username: Settings.seed.username, first_name: Settings.seed.first_name, last_name: Settings.seed.last_name
  Rails.logger.info "Seed user #{user.username} created!"
else
  Rails.logger.warn "Seed user already exists!"
end

50.times do
  User.create! email: Faker::Internet.unique.email, username: Faker::Internet.unique.user_name, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name

  name = ""
  while name.length < 5
    name = Faker::HitchhikersGuideToTheGalaxy.unique.location
  end
  p = Team.create! name: name, description: Faker::HitchhikersGuideToTheGalaxy.marvin_quote, access: [:hidden, :private, :public].sample
end


Team.all.each do |p|
  from = 0
  if rand(0..100) < 20
    m = p.members.new(user: user, role: [:participant, :owner].sample, status: [:joined, :leaved, :invited, :requested].sample)
    if m.owner?
      m.status = :joined
    end

    unless m.invited?
      rand(0..4).times do
        hours = m.target_hours.find_or_initialize_by since: rand(-3..3).months.ago.beginning_of_month
        hours.hours = rand(20..80)
        hours.member = m
        hours.save!
      end
    end

    m.save!
  else
    from = 2
  end

  rand(from..20).times do
    m = p.members.find_or_initialize_by user_id: rand(2..49)
    m.role = :participant
    m.status = [:joined, :leaved, :invited].sample
    rand(0..4).times do
      hours = m.target_hours.find_or_initialize_by since: rand(-3..3).months.ago.beginning_of_month
      hours.hours = rand(20..80)
      hours.member = m
      hours.save!
    end
    m.save!
  end

  p.save!

  p.members.each do |member|
    unless member.invited?
      if member.target_hours.empty?
        member.target_hours.new hours: rand(20..45), since: DateTime.now.to_date.beginning_of_month
      end

      rand(0..20).times do
        start_time = Faker::Time.between(2.months.ago, Date.today, :morning)
        progress = p.progresses.new(start: start_time, end: Faker::Time.between(start_time, start_time.end_of_day, :evening), member: member)
        rand(0..5).times do
          progress.tag_list.add ["rails", "dozentron", "gildamesh", "Meeting"].sample
        end
      end
    end
  end
  rand(0..5).times do
    p.tag_list.add ["rails", "dozentron", "gildamesh", "A&D"].sample
  end
  p.save!
end

name = "40 hours team"
description = "a team with exactly 40 work hours"
team = Team.create name: name, description: description
member = team.members.create(user: user, role: :owner)
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
  progress = team.progresses.new(start: start_time, end: end_time, member: member)
  progress.save!
end

wednesdays.each do |wednesday|
  start_time = DateTime.new(wednesday.year,wednesday.month,wednesday.day, 14,00)
  end_time = DateTime.new(wednesday.year,wednesday.month,wednesday.day, 18,00)
  progress = team.progresses.new(start: start_time, end: end_time, member: member)
  progress.save!
end

thursdays.each do |thursday|
  start_time = DateTime.new(thursday.year,thursday.month,thursday.day, 14,00)
  end_time = DateTime.new(thursday.year,thursday.month,thursday.day, 16,00)
  progress = team.progresses.new(start: start_time, end: end_time, member: member)
  progress.save!
end