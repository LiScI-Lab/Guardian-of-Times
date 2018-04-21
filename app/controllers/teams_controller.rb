class TeamsController < ApplicationController
  layout 'team'

  load_and_authorize_resource

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

  def index
    @teams = @current_user.involved_teams.kept
  end

  def invited
    @teams = @current_user.invited_teams.kept
  end

  def owner
    @teams = @current_user.own_teams.kept

  end

  def join
    @current_member.status = :joined
    if @current_member.save
      flash[:success] = "Successfully joined #{@team.name}"
      if @current_member.owner?
        redirect_to dashboard_team_path(@team)
      else
        redirect_to dashboard_team_member_path(@team, @current_member)
      end
    else
    end
  end

  private
  def team_params
    params.require(:team).permit([:name, :description, :tag_list])
  end
end
