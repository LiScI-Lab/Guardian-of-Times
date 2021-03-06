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

class Team::Member < ApplicationRecord
  include Statistics
  include TagOwner
  include Roles

  include DateTimeHelper

  acts_as_tagger
  acts_as_taggable

  enum status: {invited: 0, leaved: 5, revoked: 7, requested: 8, removed: 10, joined: 100}
  enum role: {participant: 0, timekeeper: 50, responsible: 90, owner: 100}

  belongs_to :user, class_name: User.name
  belongs_to :team, class_name: Team.name

  has_many :progresses, -> {order start: :desc}, class_name: Team::Progress.name, foreign_key: :team_member_id

  has_many :target_hours, -> {order since: :asc}, class_name: Team::Member::TargetHour.name, foreign_key: :team_member_id
  has_many :unavailabilities, -> {order start: :desc}, class_name: Team::Unavailability.name, foreign_key: :team_member_id

  validates :user, uniqueness: {scope: :team}

  before_create :set_joined, if: Proc.new {|member| member.owner? }

  accepts_nested_attributes_for :target_hours, reject_if: :all_blank, allow_destroy: false

  def total_time_spend
    progresses.kept.map { |p| p.time_spend }.sum
  end

  def in_month_time_spend date
    progresses.kept.in_month(date).map { |p| p.time_spend }.sum
  end

  def current_month_time_spend
    progresses.kept.this_month.map { |p| p.time_spend }.sum
  end

  def current_week_time_spend
    progresses.kept.this_week.map { |p| p.time_spend }.sum
  end

  def today_time_spend
    progresses.kept.today.map { |p| p.time_spend }.sum
  end

  def time_spend_data(date, by_team=false)
    name = if by_team then team.name else user.name end
    [name, seconds_to_hours(in_month_time_spend(date))]
  end

  def expected_time_data(date, by_team=false)
    name = if by_team then team.name else user.name end
    [name, matching_target_hours(date)]
  end

  def spend_time_percentage_data(date, by_team=false)
    name = if by_team then team.name else user.name end
    current_hours = seconds_to_hours(in_month_time_spend(date))
    target_hours = matching_target_hours(date)

    if target_hours > 0
      [name, ((100.0 / target_hours) * current_hours).to_i]
    else
      [name, 0]
    end
  end

  def current_month_actual_vs_expected_hours
    in_month_actual_vs_expected_hours(DateTime.now)
  end


  def in_month_actual_vs_expected_hours(date)
    [
      {name: I18n.t('dashboard.spend_hours'), data: [time_spend_data(date)]},
      {name: I18n.t('dashboard.target_hours'), data: [expected_time_data(date)]}
    ]
  end

  def current_month_spend_time_percentages
    in_month_spend_time_percentages(DateTime.now)
  end

  def in_month_spend_time_percentages(date)
    [
        {name: I18n.t('dashboard.spend_hours_by_percentage'), data: spend_time_percentage_data(date)},
    ]
  end

  def matching_target_hours(date)
    target_hour = target_hours.in_month(date).last
    (target_hour) ? target_hour.hours : 0
  end

  def extra_hours(date=nil)
    if target_hours.empty? || self.progresses.kept.empty?
      0
    elsif date
      (in_month_time_spend(date) - (matching_target_hours(date).hours))
    else
      progresses_started = self.progresses.kept.last.start.beginning_of_month
      targets_started = self.target_hours.kept.first.since
      member_created = self.created_at.beginning_of_month

      if member_created < progresses_started
        start_month = member_created
      else
        start_month = progresses_started
      end
      if targets_started < start_month
        start_month = targets_started
      end

      if self.leaved? or self.removed?
        end_month = self.updated_at
      else
        end_month = DateTime.now
      end

      sum = (start_month.to_date .. end_month.to_date).select do |d|
        d.day == 1
      end.map do |d|
        self.extra_hours(d)
      end.sum
      if sum > 0 then sum else 0 end
    end
  end

  def time_spend_series
    data = {}
    progresses.kept.group_by_month(:start).unscope(:order).count.map do |k,v|
      data[k.end_of_month] = seconds_to_hours(in_month_time_spend(k))
    end
    data
  end

  def current_unavailability
    unavailabilities.kept.current.first
  end

  def available?
    not current_unavailability
  end

  def running_progress?
    progresses.kept.ongoing.any?
  end

  private
  def set_joined
    self.status = :joined
  end
end
