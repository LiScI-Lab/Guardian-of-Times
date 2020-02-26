class Api::TeamsController < Api::SecuredApiController

  load_and_authorize_resource
  def index
    @teams = Team.visible(@current_user)
    render json: @teams.to_json
  end

  def involved
    @teams = @current_user.involved_teams.kept
    render json: @teams.to_json
  end

  def invited
    @teams = @current_user.invited_teams.kept
    render json: @teams.to_json
  end

  def requested
    @teams = @current_user.requested_teams.kept
    render json: @teams.to_json
  end

  def owner
    @teams = @current_user.own_teams.kept
    render json: @teams.to_json
  end

  def invite
    #TODO: Implement
  end

  def ask
    #TODO: Implement
  end

  def revoke
    #TODO: Implement
  end

  def join
    #TODO: Implement
  end

  def show
    if can? :show, @team
      render json: @team.to_json
    end
  end

  def dashboard
    #TODO: Implement
  end

  def create
    #TODO: Implement
  end

  def update
    #TODO: Implement
  end
end
