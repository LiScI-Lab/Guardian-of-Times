class Api::UsersController < Api::SecuredApiController
  def profile
    render json: @current_user.to_json
  end

  def teams
    render json: @current_user.teams.to_json
  end
end
