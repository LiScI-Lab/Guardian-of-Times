FactoryBot.define do
  # unique names
  sequence(:name) { |n| Faker::OnePiece.location+n.to_s }
  sequence(:email) { |n| "test#{n}@example.com" }
  sequence(:username) { |n|  Faker::OnePiece.character+n.to_s }

  factory :user, class: User do
    username
    email
    birth_date 20.years.ago.to_date
  end

  factory :team, class: Team do
    name
    description Faker::OnePiece.quote
  end

  factory :member, class: Team::Member do
    association :user, factory: :user
    association :team, factory: :team
  end

  factory :progress_month_before, class: Team::Progress do
    st = DateTime.now.beginning_of_month - 2.hours
    start st
    add_attribute(:end) { st+2.hours }
  end
  factory :progress_start_of_month, class: Team::Progress do
    st = DateTime.now.beginning_of_month
    start st
    add_attribute(:end) { start+2.hours }
  end
  factory :progress_end_of_month, class: Team::Progress do
    start DateTime.now.end_of_month-2.hours
    add_attribute(:end) { DateTime.now.end_of_month }
  end
  factory :progress_month_after, class: Team::Progress do
    st = DateTime.now.next_month.beginning_of_month
    start st
    add_attribute(:end) { st+2.hours }
  end

  factory :current_unavailability, class: Team::Unavailability do
    start Date.today-1.day
    add_attribute(:end) { (Date.today) }
  end
  factory :tomorrow_unavailability, class: Team::Unavailability do
    start Date.tomorrow
    add_attribute(:end) { (Date.tomorrow+1.day) }
  end
  factory :yesterday_unavailability, class: Team::Unavailability do
    start Date.yesterday-1.day
    add_attribute(:end) { (Date.yesterday) }
  end
end
