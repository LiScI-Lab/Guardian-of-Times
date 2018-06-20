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
