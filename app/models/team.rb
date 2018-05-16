class Team < ApplicationRecord
  include Statistics
  include TagOwner

  #has_ancestry
  acts_as_taggable

  has_many :members, class_name: Team::Member.name
  has_many :users, through: :members, class_name: User.name

  has_many :progresses, -> {order start: :desc}, class_name: Team::Progress.name

  validates :name, presence: true, uniqueness: {scope: :ancestry}, length: { minimum: Settings.team.name.length_minimum}
  validates :description, allow_blank: true, length: { minimum: Settings.team.description.length_minimum }

  def total_time_spend
    progresses.kept.map { |p| p.time_spend }.sum
  end

  def current_month_time_spend
    progresses.kept.this_month.map { |p| p.time_spend }.sum
  end

  def member(user)
    members.find_by(user: user)
  end

  def time_spend_series
    members.map { |m|
      { name: m.user.name, data: m.time_spend_series }
    }
  end

  def current_month_actual_vs_expected_hours
    in_month_actual_vs_expected_hours(DateTime.now)
  end

  def in_month_actual_vs_expected_hours(date)
    timings_spend = members.map { |member| member.time_spend_data(date)}
    expected_timings = members.map { |member| member.expected_time_data(date)}
    [
      {name: I18n.t('dashboard.spend_hours'), data: timings_spend},
      {name: I18n.t('dashboard.target_hours'), data: expected_timings}
    ]
  end

  def current_month_spend_time_percentages
    in_month_spend_time_percentages(DateTime.now)
  end

  def in_month_spend_time_percentages(date)
    timings_spend = members.map { |member| member.spend_time_percentage_data(date)}
    [
        {name: I18n.t('dashboard.spend_hours_by_percentage'), data: timings_spend},
    ]
  end
end
