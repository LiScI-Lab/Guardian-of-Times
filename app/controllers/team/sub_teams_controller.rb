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