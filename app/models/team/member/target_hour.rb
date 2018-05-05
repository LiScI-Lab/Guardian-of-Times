class Team::Member::TargetHour < ApplicationRecord
  belongs_to :member, class_name: Team::Member.name, foreign_key: :team_member_id

  scope :in_month, -> (date){ where('"since" <= ?', date.end_of_month) }
  scope :this_month, -> {in_month(DateTime.now)}

  validates :since, presence: true
  validates :hours, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: Settings.team.member.target_hours.minimum }

  validates :since, uniqueness: {scope: :member}
end
