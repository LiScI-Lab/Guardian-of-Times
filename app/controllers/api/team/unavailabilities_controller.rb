class Api::Team::UnavailabilitiesController

  load_and_authorize_resource :team
  load_and_authorize_resource :unavailability, through: :team

  def index
    @unavailabilities = @team.unavailabilities
    render json: @unavailabilities.to_json
  end
end
