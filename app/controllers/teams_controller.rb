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
    @selected_date = params.dig(:filter, :month)
    if @selected_date
      @selected_date = DateTime.parse @selected_date
    else
      @selected_date = DateTime.now.beginning_of_month
    end
    @available_months = @team.progresses.kept
                        .pluck(:start)
                        .map{ |d| d.beginning_of_month }
                        .uniq
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
    member.discarded_at = nil
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
