class Team::Progress < ApplicationRecord
  belongs_to :team, class_name: Team.name

  has_many :members_progresses, class_name: Team::MembersProgresses.name, foreign_key: :team_progress_id
  has_many :members, class_name: Team::Member.name, through: :members_progresses

  has_many :tag_targets, as: :target, class_name: Tag::Target.name
  has_many :tags, through: :tag_targets, class_name: Tag.name

  scope :in_month, -> (date){where(start: date.beginning_of_month..date.end_of_month)}
  scope :this_month, -> {in_month(DateTime.now)}
  scope :ongoing, -> {where end: nil}

  validates :start, presence: true

  after_initialize :set_start

  def finished?
    not self[:end].nil?
  end

  def end
    self[:end] || Time.zone.now
  end

  def time_spend
    ActiveSupport::Duration.build((self.end - start).seconds)
  end

  private
  def set_start
    self.start = start || DateTime.now
  end
end
