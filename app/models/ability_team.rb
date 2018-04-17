module AbilityTeam
  include CanCan::Ability

  def initialize_team(user, member)
    can [:index, :invited, :owner], Team
    can [:create, :new], Team

    if member
      can [:show],      Team, members: {id: member.id, status: Team::Member.statuses[:joined]}
      can [:dashboard], Team, members: {id: member.id, role: Team::Member.roles[:owner]}
      can [:join],      Team, members: {id: member.id, status: Team::Member.statuses[:invited]}
      can [:index],  :sub_team do
        member.team.is_root? and ((member.joined? and member.team.has_children?) or member.owner?)
      end

      can [:create], :sub_team do
        member.owner? and member.team.is_root?
      end

      can [:index],                           Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:owner]}}
      can [:show, :dashboard],                Team::Member, id: member.id
      can [:show, :dashboard, :new, :invite], Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:owner]}}

      can [:index, :show],                        Team::Progress,           team: {members: {id: member.id, role: Team::Member.roles[:owner]}}
      can [:create],                              Team::Progress,           members_progresses: {team_member_id: member.id}
      can [:index, :show, :edit, :update, :stop], Team::Progress,           members_progresses: {team_member_id: member.id}
      can [:destroy],                             Team::Progress.kept,      members_progresses: {team_member_id: member.id}
      can [:restore],                             Team::Progress.discarded, members_progresses: {team_member_id: member.id}

      can [:create, :index], :export
    end
  end
end
