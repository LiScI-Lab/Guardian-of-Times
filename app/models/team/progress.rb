class Team::Progress < ApplicationRecord
  extend TimeSplitter::Accessors
  acts_as_taggable

  belongs_to :team, class_name: Team.name

  belongs_to :member, class_name: Team::Member.name, foreign_key: :team_member_id
  has_one :user, class_name: User.name, through: :member

  scope :in_month, -> (date){where(start: date.beginning_of_month..date.end_of_month)}
  scope :this_month, -> {in_month(DateTime.now)}
  scope :ongoing, -> {where end: nil}
  scope :finished, -> {where.not end: nil}

  validates :start, presence: true

  after_initialize :set_start

  split_accessor :start, :end, date_format: I18n.t('date.formats.default'), time_format: I18n.t('time.formats.default')

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
