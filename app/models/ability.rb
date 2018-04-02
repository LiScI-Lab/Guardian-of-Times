class Ability
  include CanCan::Ability

  include AbilityProject

  def initialize(user, member)
    if user
      can [:index], :welcome
      can [:show], User, id: user.id
      can [:edit], User, id: user.id

      initialize_project(user, member)
    end
  end
end
