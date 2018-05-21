class Team::UnavailabilitiesController < SecurityController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :unavailability, through: :team

  def index
    @unavailabilities = @team.unavailabilities
  end
end
