class Team::Member < ApplicationRecord
  include DateTimeHelper

  acts_as_tagger

  enum status: {invited: 0, leaved: 5, removed: 10, joined: 100}
  enum role: {participant: 0, timekeeper: 50, responsible: 90, owner: 100}

  belongs_to :user, class_name: User.name
  belongs_to :team, class_name: Team.name

  has_many :progresses, -> {order start: :desc}, class_name: Team::Progress.name, foreign_key: :team_member_id

  has_many :target_hours, -> {order since: :asc}, class_name: Team::Member::TargetHour.name, foreign_key: :team_member_id

  validates :user, uniqueness: {scope: :team}

  before_create :set_joined, if: Proc.new {|member| member.owner? or (not member.team.root?) }

  accepts_nested_attributes_for :target_hours, reject_if: :all_blank, allow_destroy: false

  def total_time_spend
    progresses.kept.map { |p| p.time_spend }.sum
  end

  def current_month_time_spend
    progresses.kept.this_month.map { |p| p.time_spend }.sum
  end

  def time_spend_data
    [user.realname, seconds_to_hours(current_month_time_spend)]
  end

  def expected_time_data
    [user.realname, recent_target_hours]
  end

  def actual_vs_expected_hours
    [
      {name: "Time spend", data: [time_spend_data]},
      {name: "Time expected", data: [expected_time_data]}
    ]
  end

  def recent_target_hours
    (target_hours.last) ? target_hours.last.hours : 0
  end

  def in_month_time_spend date
    progresses.kept.in_month(date).map { |p| p.time_spend }.sum
  end

  def time_spend_series
    data = {}
    progresses.kept.group_by_month(:start).count.map do |k,v|
      data[k.end_of_month] = in_month_time_spend(k) /3600
    end
    data
  end

  private
  def set_joined
    self.status = :joined
  end
end
