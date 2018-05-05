class Ability
  include CanCan::Ability

  include AbilityTeam

  def initialize(user, member)
    can [:index], :welcome

    if user
      can [:show, :dashboard], User, id: user.id
      can [:edit, :update], User, id: user.id

      initialize_team(user, member)
    end
  end
end
