class Project < ApplicationRecord
  has_many :members, class_name: "Project::Member"
  has_many :users, through: :project_members, class_name: "User"

  has_many :tag_affecteds, as: :affecred, class_name: "TagAffected"
  has_many :tags, through: :tag_affecteds, class_name: "Tag"

  validates :name, presence: true, length: { minimum: Settings.project.name.length_minimum }
  validates :description, allow_blank: true, length: { minimum: Settings.project.description.length_minimum }
end
