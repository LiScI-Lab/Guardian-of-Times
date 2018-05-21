class Team::Unavailability < ApplicationRecord
  extend TimeSplitter::Accessors

  belongs_to :team, class_name: Team.name

  belongs_to :member, class_name: Team::Member.name, foreign_key: :team_member_id
  has_one :user, class_name: User.name, through: :member

  validates :start, presence: true
  validates :end, timeliness: { after: :start, type: :datetime, allow_nil: true }

  scope :current, -> {where('"team_unavailabilities"."start" <= ? and ("team_unavailabilities"."end" IS NULL or "team_unavailabilities"."end" >= ?)', Date.today, Date.today)}

  after_initialize :set_start

  split_accessor :start, :end, date_format: I18n.t('date.formats.default'), time_format: I18n.t('time.formats.default')

  private
  def set_start
    self.start = start || DateTime.now
  end
end
