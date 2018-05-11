# coding: utf-8
class Team::MembersController < SecurityController
  include DateTimeHelper
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, through: :team

  def index
    @members = @team.members
  end

  def show
    redirect_to dashboard_team_member_path(@team, @member)
  end

  def dashboard
    # ===== DO NOT KILL THIS ===========================================
      # spend_hours = @team.members.map { |m|
      #   [m.user.realname, seconds_to_hours(m.current_month_time_spend)]
      # }
      # target_hours = @team.members.map { |m|
      #   [m.user.realname, m.recent_target_hours]
      # }

      # @time_spend_with_target_hours = [
      #   {name: "Time spend", data: spend_hours},
      #   {name: "Time Vertrag", data: target_hours}
      # ]
    # ===== DO NOT KILL THIS ===========================================
  end

  def new
  end

  def edit
  end

  def update
    if @member.update member_params
      flash[:success] = "Member successfully updated"
      redirect_to dashboard_team_member_path(@team, @member)
    else
      flash[:error] = "Member not updated"
      render 'edit'
    end
  end

  def restore
    if @member.joined!
      flash[:success] = "Member is rejoined!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to team_members_path(@team)
  end

  def destroy
    if @member.removed!
      flash[:success] = "Member is removed!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to team_members_path(@team)
  end

  private
  def member_params
    params.require(:member).permit(:id, target_hours_attributes: [
        :id, :since, :hours
    ])
  end
end
