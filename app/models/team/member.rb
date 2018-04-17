class Team::Member < ApplicationRecord
  enum status: {invited: 0, removed: 5, leaved: 10, joined: 100}
  enum role: {participant: 0, timekeeper: 50, responsible: 90, owner: 100}

  belongs_to :user, class_name: User.name
  belongs_to :team, class_name: Team.name

  has_many :progresses, -> {order start: :desc}, class_name: Team::Progress.name, foreign_key: :team_member_id

  has_many :target_hours, class_name: Team::Member::TargetHour.name, foreign_key: :team_member_id

  has_many :tag_targets, as: :member, class_name: Tag::Target.name

  validates :user, uniqueness: {scope: :team}

  before_create :set_joined, if: Proc.new {|member| member.owner? or (not member.team.root?) }

  def total_time_spend
    progresses.kept.map { |p| p.time_spend }.sum
  end

  def current_month_time_spend
    progresses.kept.this_month.map { |p| p.time_spend }.sum
  end

  private
  def set_joined
    self.status = :joined
  end
end