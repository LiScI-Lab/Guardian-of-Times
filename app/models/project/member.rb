class Project::Member < ApplicationRecord
  enum status: {leaved: -10, invited: 0, joined: 10}
  enum role: {participant: 0, owner: 100}

  belongs_to :user, class_name: "User"
  belongs_to :project, class_name: "Project"

  has_and_belongs_to_many :progresses, -> {order start: :desc}, class_name: "Project::Progress", foreign_key: :project_member_id, association_foreign_key: :project_progress_id

  has_many :target_hours, class_name: "Project::TargetHour", foreign_key: :project_member_id

  validates :user, uniqueness: {scope: :project}

  def total_time_spend
    progresses.kept.map { |p| p.time_spend }.sum
  end

  def current_month_time_spend
    progresses.kept.this_month.map { |p| p.time_spend }.sum
  end
end
