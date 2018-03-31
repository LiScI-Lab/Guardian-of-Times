class Ability
  include CanCan::Ability

  include AbilityProject

  def initialize(user, member)
    if user
      can [:index], :welcome


      initialize_project(user, member)
    end
  end
end
