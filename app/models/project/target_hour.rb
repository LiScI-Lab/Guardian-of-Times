class Project::TargetHour < ApplicationRecord
  belongs_to :member, class_name: "Project::Member", foreign_key: :project_member_id

  validates :since, presence: true
  validates :hours, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: Settings.project.member.target_hours.minimum }
end
