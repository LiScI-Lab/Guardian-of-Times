class Project::Member < ApplicationRecord
  enum role: {invited: 0, participant: 1, owner: 100}

  belongs_to :user, class_name: "User"
  belongs_to :project, class_name: "Project"

  has_and_belongs_to_many :progresses, join_table: :project_members_progresses, class_name: "Project::Progress", foreign_key: :project_member_id, association_foreign_key: :project_progress_id

  validates :target_hours, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: Settings.project.member.target_hours.minimum }
  validates :user, uniqueness: {scope: :project}

  def total_time_spend
    #TODO: how to summarize each duration ?
    durations = progresses.all.map{ |p| p.end-p.start }
    puts durations
    # raise "dump"
    -1
  end
end
