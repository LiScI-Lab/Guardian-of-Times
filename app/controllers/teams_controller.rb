class TeamsController < SecurityController
  layout 'team'

  load_and_authorize_resource

  def index
    @teams = Team.visible(@current_user)
  end

  def involved
    @teams = @current_user.involved_teams.kept
  end

  def invited
    @teams = @current_user.invited_teams.kept
  end

  def requested
    @teams = @current_user.requested_teams.kept
  end

  def owner
    @teams = @current_user.own_teams.kept
  end


  def show
    if can? :dashboard, @team
      redirect_to dashboard_team_path(@team)
    else
      redirect_to dashboard_team_member_path(@team, @current_member)
    end
  end

  def dashboard
  end

  def subs
  end

  def new
  end

  def create
    @team.members.new user: @current_user, role: :owner
    if @team.save
      flash[:success] = "Team successfully created"
      redirect_to @team
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @team.update team_params
      flash[:success] = "Team successfully updated"
      redirect_to @team
    else
      render 'edit'
    end
  end

  def invite
    @user = User.find params[:user_id]
    member = @team.members.find_or_initialize_by user: @user
    if member.save
      @message = "#{@user.name} successfully invited"
    else
      @message = "Something went wrong"
    end
  end

  def ask
    member = @team.members.find_or_initialize_by user: @current_user

    if member.requested!
      flash[:success] = "Access requested!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_back fallback_location: teams_path
  end

  def revoke
    member = @team.members.find_or_initialize_by user: @current_user

    if member.revoked!
      flash[:success] = "Request revoked!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_back fallback_location: teams_path
  end


  def join
    unless @current_member
      @current_member = @team.members.new user: @current_user
    end
    @current_member.status = :joined
    if @current_member.save
      flash[:success] = "Successfully joined #{@team.name}"
      if @current_member.owner?
        redirect_to dashboard_team_path(@team)
      else
        redirect_to edit_team_member_path(@team, @current_member)
      end
    else
      flash[:error] = "Something went wrong"
      redirect_back fallback_location: teams_path
    end
  end

  private
  def team_params
    p = params.require(:team).permit([:name, :description, :access, :tag_list, :own_tag_list])
    if p[:own_tag_list].present?
      p[:own_tag_list] = {owner: @current_member, tag_list: p[:own_tag_list]}
    end
    p
  end
end
