module Project::AbilityProgress
  include CanCan::Ability

  def initialize_progress(user, member)
    #TODO: restrict usage
    can :manage, :all
    # if member
    #   can [:manage], Project::Progress, members: {id: member.id}
    # end
  end
end
