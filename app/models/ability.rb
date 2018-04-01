class Ability
  include CanCan::Ability

  include AbilityProject
  include Project::AbilityProgress

  def initialize(user, member)
    if user
      can [:index], :welcome
      can [:show], User, id: user.id

      initialize_project(user, member)
      initialize_progress(user, member)
    end
  end
end
