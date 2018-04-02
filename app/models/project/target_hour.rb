class Project::TargetHour < ApplicationRecord
  belongs_to :member, class_name: "Project::Member", foreign_key: :project_member_id

  validates :since, presence: true
  validates :hours, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: Settings.project.member.target_hours.minimum }

  def total_time_spend
    progresses.map { |p| p.time_spend }.sum
  end

  def current_month_time_spend
    progresses.this_month.map { |p| p.time_spend }.sum
  end
end
