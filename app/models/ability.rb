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

class Ability
  include CanCan::Ability

  include AbilityTeam

  def initialize(user, member)
    can [:index], :welcome

    if user
      can [:show, :dashboard, :token], User, id: user.id
      can [:edit, :update, :delete, :destroy], User, id: user.id

      initialize_team(user, member)

    end
  end
end
