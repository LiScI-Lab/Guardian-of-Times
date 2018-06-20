############
##
## Copyright 2018 M. Hoppe & N. Justus
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############

# coding: utf-8
class Team::MembersController < SecurityController
  include DateTimeHelper
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, through: :team

  def index
    @members = @team.members
  end

  def outstanding
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

  def accept
    if @member.joined!
      flash[:success] = "Member joined!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_back fallback_location: outstanding_team_members_path(@team)
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
    redirect_back fallback_location: team_members_path(@team)
  end

  def destroy
    if @member.joined?
      if @member.removed!
        flash[:success] = "Member is removed!"
      else
        flash[:error] = "Something went wrong"
      end
    else
      if @member.discard
        flash[:success] = "Member is removed!"
      else
        flash[:error] = "Something went wrong"
      end
    end
    redirect_back fallback_location: team_members_path(@team)
  end

  private
  def member_params
    p = params.require(:member).permit(:id, :tag_list, :own_tag_list, :show_online_status, :show_tracking_status, target_hours_attributes: [
        :id, :since, :hours
    ])
    if p[:own_tag_list].present?
      p[:own_tag_list] = {owner: @current_member, tag_list: p[:own_tag_list]}
    end
    p
  end
end
