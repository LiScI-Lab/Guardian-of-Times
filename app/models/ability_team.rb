module AbilityTeam
  include CanCan::Ability

  def initialize_team(user, member)
    can [:index, :invited, :owner], Team
    can [:create, :new], Team

    if member
      can [:show], Team, members: {id: member.id}
      can [:dashboard], Team, members: {id: member.id, role: Team::Member.roles[:owner]}
      can [:join], Team, members: {id: member.id, status: Team::Member.statuses[:invited]}

      can [:index],                           Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:owner]}}
      can [:show, :dashboard],                Team::Member, id: member.id
      can [:show, :dashboard, :new, :invite], Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:owner]}}

      can [:index, :show], Team::Progress, team: {members: {id: member.id, role: Team::Member.roles[:owner]}}
      can [:index, :show, :stop, :destroy, :restore], Team::Progress, members: {id: member.id}
      can [:create, :edit, :update], Team::Progress, team: {members: {id: member.id}}
      can [:create, :index], :export
    end
  end
end
