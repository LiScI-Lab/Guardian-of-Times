module AbilityProject
  include CanCan::Ability

  def initialize_project(user, member)
    can [:index, :invited, :owner], Project
    can [:create, :new],            Project

    if member
      can [:show],      Project, members: {id: member.id}
      can [:dashboard], Project, members: {id: member.id, role: Project::Member.roles[:owner]}
      can [:join],      Project, members: {id: member.id, status: Project::Member.statuses[:invited]}

      can [:index],             Project::Member, project: {members: {id: member.id, role: Project::Member.roles[:owner]}}
      can [:show, :dashboard],  Project::Member, id: member.id
      can [:show, :dashboard],  Project::Member, project: {members: {id: member.id, role: Project::Member.roles[:owner]}}

      can [:index, :show],        Project::Progress, project: {members: {id: member.id, role: Project::Member.roles[:owner]}}
      can [:index, :show, :stop], Project::Progress, members: {id: member.id}
      can [:create, :edit, :update],              Project::Progress, project: {members: {id: member.id}}

      can [:create, :index], :export
    end
  end
end
