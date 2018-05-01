class Team < ApplicationRecord
  has_ancestry
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
      { name: m.user.realname, data: m.time_spend_series }
    }
  end

  def actual_vs_expected_hours
    timings_spend = members.map(&:time_spend_data)
    expected_timings = members.map(&:expected_time_data)
    # raise 'dump'
    [
      {name: "Time spend", data: timings_spend},
      {name: "Time expected", data: expected_timings}
    ]
  end
end
