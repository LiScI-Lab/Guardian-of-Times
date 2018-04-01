class Project::Progress < ApplicationRecord
  has_and_belongs_to_many :members, class_name: "Project::Member", foreign_key: :project_progress_id, association_foreign_key: :project_member_id

  has_many :tag_affecteds, as: :affected, class_name: "TagAffected"
  has_many :tags, through: :tag_affecteds, class_name: "Tag"

  validates :start, presence: true
end
