class Project::Progress < ApplicationRecord
  has_and_belongs_to_many :project_members, join_table: :project_progress_participants, class_name: "Project::Member"

  has_many :tag_affecteds, as: :affecred, class_name: "TagAffected"
  has_many :tags, through: :tag_affecteds, class_name: "Tag"

  validates :start, presence: true
end