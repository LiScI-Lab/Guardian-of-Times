class Team::Member::UnavailabilitiesController < SecurityController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, class: Team::Member
  load_and_authorize_resource :unavailabilities, through: :member, class: Team::Unavailability

  def index
    @unavailability = Team::Unavailability.new(start: DateTime.now.to_date)
  end

  def create
    @unavailability = Team::Unavailability.new(unavailability_params)
    @unavailability.member = @member
    @unavailability.team = @team
    if @unavailability.save
      flash[:success] = "Unavailablity successfully added"
      redirect_to team_member_unavailabilities_path(@team, @member)
    else
      flash[:error] = "Unavailablity not created"
      redirect_to team_member_unavailabilities_path(@team, @member)
    end
  end

  def destroy
    unavailability = Team::Unavailability.find params[:id]
    unavailability.discard
    redirect_to team_member_unavailabilities_path(@team, @member)
  end

  private
  def unavailability_params
    params.require(:unavailability).permit([:start,:end])
  end
end
