class Team::SubTeamsController < SecurityController
  layout 'team'

  load_and_authorize_resource :team
  authorize_resource :sub_team, class: false

  def index

  end

  def new
    @subteam = Team.new parent: @team
  end

  def create
    @subteam = Team.new team_params
    @subteam.parent = @team
    @subteam.members.new(user: @current_user, role: :owner)

    if @subteam.save
      redirect_to team_sub_teams_path(@team)
    else
      render 'new'
    end
  end

  private
  def team_params
    params.require(:team).permit([:name, :description, :parent_id])
  end
end