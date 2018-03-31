class Project::Member < ApplicationRecord
  enum role: {member: 0, owner: 100}

  belongs_to :user, class_name: "User"
  belongs_to :project, class_name: "Project"

  has_and_belongs_to_many :project_progresses, join_table: :project_progress_participants, class_name: "Project::Progress"
end
