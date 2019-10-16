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

class UsersController < SecurityController
  load_and_authorize_resource

  def show
    redirect_to dashboard_user_path(@user)
  end

  def dashboard
    @selected_date = params.dig(:filter, :month)
    if @selected_date
      @selected_date = DateTime.parse @selected_date
    else
      @selected_date = DateTime.now.beginning_of_month
    end
    @available_months = @user.progresses.kept
                          .pluck(:start)
                          .map{ |d| d.beginning_of_month }
                          .uniq
    #list recently used teams for the current user
    if @current_user == @user
      member_ids = Team::Member.where(user: @current_user).pluck(:id)
      #progresses for the current user; unique by team
      progresses = Team::Progress.where(member: member_ids)
                     .order(start: :desc)
      teams = progresses.joins(:team)
                .distinct(:team_id)
                .pluck(:team_id)
                .take(3)
      @last_members = teams.map{ |id| Team::Member.find_by(team: id, user: @current_user) }
    else
      @last_members = []
    end
  end

  def edit
  end

  def update
    if @current_user.update user_params
      flash[:success] = "User successfully updated"
      redirect_to @current_user
    else
      render 'edit'
    end
  end

  def delete
  end

  def destroy
    unless Settings.user.discard.disabled
      sign_out @user
      if @user.discard
        flash[:success] = "User successfully discarded"
        redirect_to '/'
      else
        flash[:error] = "User not discarded"
        redirect_to :back
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:department, :birth_date,
                                 :last_name, :first_name, :email,
                                 :avatar, :avatar_cache, :avatar_type)
  end
end
