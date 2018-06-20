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
    params.require(:unavailability).permit([:start_date, :end_date, :description])
  end
end
