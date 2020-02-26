class Api::UsersController < Api::SecuredApiController
  def dashboard

  end

  def profile
    render json: @current_user.to_json
  end

  def teams
    render json: @current_user.teams.to_json
  end

  def show

  end

  def update
    #TODO: Implement
  end

  def destroy
    #TODO: Implement
  end
end
