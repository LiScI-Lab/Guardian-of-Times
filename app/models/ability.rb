class Ability
  include CanCan::Ability

  include AbilityTeam

  def initialize(user, member)
    if user
      can [:index], :welcome
      can [:show], User, id: user.id
      can [:edit, :update], User, id: user.id

      initialize_team(user, member)
    end
  end
end
