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
