class Team::MembersController < ApplicationController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, through: :team

  def index
  end

  def show
    redirect_to dashboard_team_member_path(@team, @member)
  end

  def dashboard
  end

  def new
  end

  def invite
    invite_params[:users].reject { |c| c.empty? }.each do |id|
      @team.members.find_or_initialize_by user: User.find(id)
    end
    if @team.save
      flash[:success] = "Users are invited!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to team_members_path(@team)
  end

  private
  def invite_params
    params.require(:invitations).permit(users: [])
  end
end