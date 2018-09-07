############
##
## Copyright 2018 M. Hoppe & N. Justus
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############

class Team::Progress < ApplicationRecord
  extend TimeSplitter::Accessors
  include TagOwner

  acts_as_taggable

  belongs_to :team, class_name: Team.name

  belongs_to :member, class_name: Team::Member.name, foreign_key: :team_member_id
  has_one :user, class_name: User.name, through: :member

  scope :at_day, -> (date){where(start: date.beginning_of_day..date.end_of_day)}
  scope :in_week, -> (date){where(start: date.beginning_of_week..date.end_of_week)}
  scope :in_months, -> (dates){dates.map {|date| in_month(date)}.reduce {|acc, elem| acc.or(elem)}}
  scope :in_month, -> (date){where(start: date.beginning_of_month..date.end_of_month)}

  scope :today, -> {at_day(DateTime.now)}
  scope :this_week, -> {in_week(DateTime.now)}
  scope :this_month, -> {in_month(DateTime.now)}


  scope :ongoing, -> {where end: nil}
  scope :finished, -> {where.not end: nil}

  validates :start, presence: true
  validates :end, timeliness: { after: :start, type: :datetime, allow_nil: Proc.new {
    not self.member.running_progress?
  }}

  after_initialize :set_start

  split_accessor :start, :end, date_format: I18n.t('date.formats.default'), time_format: I18n.t('time.formats.default')

  def finished?
    not self[:end].nil?
  end

  def end
    self[:end] || Time.zone.now
  end

  def time_spend
    ActiveSupport::Duration.build((self.end - self.start).seconds)
  end

  private
  def set_start
    self.start = self.start || DateTime.now
  end
end
