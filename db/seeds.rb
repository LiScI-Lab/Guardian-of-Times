# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.random = Random.new(42)

user = User.first
if user
  20.times do
    name = ""
    while name.length < 5
      name = Faker::HitchhikersGuideToTheGalaxy.location
    end
    p = Project.new name: name, description: Faker::HitchhikersGuideToTheGalaxy.marvin_quote
    p.members.new user: user, role: [:invited, :participant, :owner].sample
    p.save!
  end
end