class Team::Unavailability < ApplicationRecord
  belongs_to :team, class_name: Team.name

  belongs_to :member, class_name: Team::Member.name, foreign_key: :team_member_id
  has_one :user, class_name: User.name, through: :member

  validates :start, presence: true

end
