class UsersController < ApplicationController
  load_and_authorize_resource

  def show
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

  private
  def user_params
    params.require(:user).permit(:department, :birthdate)
  end
end
