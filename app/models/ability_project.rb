module AbilityProject
  include CanCan::Ability

  def initialize_project(user, member)
    if member
      can [:show], Project, members: {id: member.id}
    end
  end
end
