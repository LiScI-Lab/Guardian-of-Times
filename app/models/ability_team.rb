module AbilityTeam
  include CanCan::Ability

  def initialize_team(user, member)
    alias_action :upload, to: :import

    can [:index, :invited, :owner], Team
    can [:create, :new], Team

    can [:join],    Team, access: Team.accesses[:public]
    can [:ask],     Team, access: Team.accesses[:private]
    cannot [:ask],  Team, members: {user: user, status: Team::Member.statuses[:requested]..Team::Member.statuses[:joined]}
    can [:revoke],  Team, members: {user: user, status: Team::Member.statuses[:requested]}
    can [:join],    Team, members: {user: user, status: Team::Member.statuses[:invited]..Team::Member.statuses[:leaved]}
    cannot [:join], Team, members: {user: user, status: Team::Member.statuses[:removed]..Team::Member.statuses[:joined]}
    can [:show],    Team, members: {user: user, status: Team::Member.statuses[:joined]}

    can [:destroy],  Team::Member, user: user, status: Team::Member.statuses[:joined]
    cannot [:destroy],  Team::Member, user: user, role: Team::Member.roles[:owner]

    if member
      can [:dashboard, :update, :invite], Team, members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}
      cannot [:update],                   Team, members: {id: member.id, role: Team::Member.roles[:responsible]}


      can [:index],                                                         Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      can [:show, :dashboard, :update],                                     Team::Member, id: member.id
      can [:show, :dashboard, :update, :new, :invite, :destroy, :restore],  Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}

      cannot [:restore],                                                    Team::Member do |member|
        not member.removed?
      end
      cannot [:destroy],                                                    Team::Member do |member|
        not member.joined?
      end

      can [:index, :show, :export],               Team::Progress,           team: {members: {id: member.id, role: Team::Member.roles[:responsible]..Team::Member.roles[:owner]}}
      can [:create, :start, :import, :export],    Team::Progress,           member: member
      can [:update, :stop, :restart, :duplicate], Team::Progress,           member: member
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
