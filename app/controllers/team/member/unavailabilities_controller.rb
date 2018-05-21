class Team::Member::UnavailabilitiesController < SecurityController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, class: Team::Member
  load_and_authorize_resource :unavailability, through: :member, class: Team::Unavailability

  def index
    @unavailability = Team::Unavailability.new(start: DateTime.now.to_date)
    @unavailabilities = @member.unavailabilities
  end

  def create
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

  def update
    if @unavailability.update unavailability_params
      flash[:success] = "Progress successfully updated"
      redirect_to team_member_unavailabilities_path(@team, @member)
    else
      flash[:error] = "Progress not updated"
      render 'index'
    end
  end

  def destroy
    @unavailability.discard
    redirect_to team_member_unavailabilities_path(@team, @member)
  end

  private
  def unavailability_params
    params.require(:unavailability).permit([:start_date, :end_date])
  end
end
