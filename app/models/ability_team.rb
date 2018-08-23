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

module AbilityTeam
  include CanCan::Ability

  def initialize_team(user, member)
    alias_action :upload, to: :import

    can [:index, :invited, :involved, :requested, :owner], Team
    can [:create, :new], Team

    can [:join],    Team, access: Team.accesses[:public]
    can [:ask],     Team, access: Team.accesses[:private]
    cannot [:ask],  Team, members: {user: user, status: Team::Member.statuses[:requested]..Team::Member.statuses[:joined]}
    can [:revoke],  Team, members: {user: user, status: Team::Member.statuses[:requested], discarded_at: nil}
    can [:join],    Team, members: {user: user, status: Team::Member.statuses[:invited]..Team::Member.statuses[:leaved]}
    cannot [:join], Team, members: {user: user, status: Team::Member.statuses[:removed]..Team::Member.statuses[:joined]}
    can [:show],    Team, members: {user: user, status: Team::Member.statuses[:joined]}

    can [:destroy],  Team::Member, user: user, status: Team::Member.statuses[:joined]
    cannot [:destroy],  Team::Member, user: user, role: Team::Member.roles[:owner]

    if member
      can [:dashboard, :update, :invite], Team, members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}
      cannot [:update],                   Team, members: {id: member.id, role: Team::Member.roles[:responsible]}


      can [:index],                                     Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      can [:new, :outstanding],                         Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      can [:show, :dashboard, :update],                 Team::Member, id: member.id
      can [:show, :dashboard, :update, :new, :invite],  Team::Member, status: [Team::Member.statuses[:joined], Team::Member.statuses[:leaved], Team::Member.statuses[:removed]], team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}

      can [:accept],                                    Team::Member, status: Team::Member.statuses[:requested], team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      can [:restore],                                   Team::Member, status: Team::Member.statuses[:removed], team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      can [:destroy],                                   Team::Member, status: [Team::Member.statuses[:joined], Team::Member.statuses[:requested], Team::Member.statuses[:invited]], team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      cannot [:destroy],                                Team::Member, id: member.id
      cannot [:destroy],                                Team::Member do |m|
        Team::Member.roles[m.role] >= Team::Member.roles[member.role]
      end

      can [:index, :show, :export],               Team::Progress,           team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      can [:create, :start, :import, :export],    Team::Progress,           member: member
      can [:update, :stop, :restart, :duplicate], Team::Progress.kept,      member: member
      can [:destroy],                             Team::Progress.kept,      member: member
      can [:restore],                             Team::Progress.discarded, member: member

      cannot [:restart],                          Team::Progress do |progress|
        not (progress.member.progresses.kept.first == progress and progress.start.to_date == Date.today)
      end

      can [:show,:index],                              Team::Unavailability, team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      can [:show, :create, :edit, :update, :destroy],  Team::Unavailability, member: member

      can [:create, :index], :export
    end
  end
end
