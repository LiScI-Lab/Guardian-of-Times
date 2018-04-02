module AbilityProject
  include CanCan::Ability

  def initialize_project(user, member)
    can [:index, :invited, :owner], Project
    can [:create, :new], Project

    if member
      can [:show], Project, members: {id: member.id}
      can [:join], Project, members: {id: member.id, status: Project::Member.statuses[:invited]}

      can [:index], Project::Member, project: {members: {id: member.id, role: Project::Member.roles[:owner]}}
      can [:show], Project::Member, id: member.id
      can [:show], Project::Member, project: {members: {id: member.id, role: Project::Member.roles[:owner]}}

      can [:create, :index], :export
    end
  end
end
