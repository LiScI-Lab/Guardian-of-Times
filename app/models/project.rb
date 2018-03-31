class Project < ApplicationRecord
  has_many :project_members, class_name: "Project::Member"
  has_many :users, through: :project_members, class_name: "User"

  has_many :tag_affecteds, as: :affecred, class_name: "TagAffected"
  has_many :tags, through: :tag_affecteds, class_name: "Tag"
end
