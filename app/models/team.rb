class Team < ApplicationRecord
  has_ancestry

  has_many :members, class_name: Team::Member.name
  has_many :users, through: :members, class_name: User.name

  has_many :tag_targets, as: :target, class_name: Tag::Target.name
  has_many :tags, through: :tag_targets, class_name: Tag.name

  has_many :progresses, -> {order start: :desc}, class_name: Team::Progress.name

  validates :name, presence: true, uniqueness: {scope: :ancestry}, length: { minimum: Settings.team.name.length_minimum}
  validates :description, allow_blank: true, length: { minimum: Settings.team.description.length_minimum }

  def total_time_spend
    progresses.kept.map { |p| p.time_spend }.sum
  end

  def current_month_time_spend
    progresses.kept.this_month.map { |p| p.time_spend }.sum
  end

  def member(user)
    members.find_by(user: user)
  end
end