class Team::Progress < ApplicationRecord
  extend TimeSplitter::Accessors
  include TagOwner

  acts_as_taggable

  belongs_to :team, class_name: Team.name

  belongs_to :member, class_name: Team::Member.name, foreign_key: :team_member_id
  has_one :user, class_name: User.name, through: :member

  scope :at_day, -> (date){where(start: date.beginning_of_day..date.end_of_day)}
  scope :in_week, -> (date){where(start: date.beginning_of_week..date.end_of_week)}
  scope :in_month, -> (date){where(start: date.beginning_of_month..date.end_of_month)}

  scope :today, -> {at_day(DateTime.now)}
  scope :this_week, -> {in_week(DateTime.now)}
  scope :this_month, -> {in_month(DateTime.now)}


  scope :ongoing, -> {where end: nil}
  scope :finished, -> {where.not end: nil}

  validates :start, presence: true
  validates :end, timeliness: { after: :start, type: :datetime, allow_nil: true }

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
