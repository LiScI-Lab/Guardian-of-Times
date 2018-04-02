class Project < ApplicationRecord
  has_many :members, class_name: "Project::Member"
  has_many :users, through: :members, class_name: "User"

  has_many :tag_affecteds, as: :affected, class_name: "TagAffected"
  has_many :tags, through: :tag_affecteds, class_name: "Tag"

  has_many :progresses, -> {order start: :desc}, class_name: "Project::Progress"


  validates :name, presence: true, length: { minimum: Settings.project.name.length_minimum}
  validates :description, allow_blank: true, length: { minimum: Settings.project.description.length_minimum }

  def member(user)
    members.find_by(user_id: user.id)
  end
end
