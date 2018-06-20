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

class Team::Member::TargetHour < ApplicationRecord
  belongs_to :member, class_name: Team::Member.name, foreign_key: :team_member_id

  scope :in_month, -> (date){ where('"since" <= ?', date.end_of_month) }
  scope :this_month, -> {in_month(DateTime.now)}

  validates :since, presence: true
  validates :hours, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: Settings.team.member.target_hours.minimum }

  validates :since, uniqueness: {scope: :member}
end
