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
      can [:create],                              Team::Progress,           member: member
      can [:index, :show, :edit, :update, :stop], Team::Progress,           member: member
      can [:destroy],                             Team::Progress.kept,      member: member
      can [:restore],                             Team::Progress.discarded, member: member

      can [:create, :index], :export
    end
  end
end
