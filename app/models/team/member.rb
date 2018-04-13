class Team::Member < ApplicationRecord
  enum status: {leaved: -10, invited: 0, joined: 10}
  enum role: {participant: 0, owner: 100}

  belongs_to :user, class_name: User.name
  belongs_to :team, class_name: Team.name

  has_and_belongs_to_many :progresses, -> {order start: :desc}, class_name: Team::Progress.name, foreign_key: :team_member_id, association_foreign_key: :team_progress_id

  has_many :target_hours, class_name: Team::Member::TargetHour.name, foreign_key: :team_member_id

  has_many :tag_targets, as: :member, class_name: Tag::Target.name

  validates :user, uniqueness: {scope: :team}

  def total_time_spend
    progresses.kept.map { |p| p.time_spend }.sum
  end

  def current_month_time_spend
    progresses.kept.this_month.map { |p| p.time_spend }.sum
  end
end
