module AbilityProject
  include CanCan::Ability

  def initialize_project(user, member)
    can [:create], Project

    if member
      can [:show], Project, members: {id: member.id}
    end
  end
end
