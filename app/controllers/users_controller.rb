class UsersController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def edit
  end

  def update
    # render plain:  params.inspect
    @current_user.attributes = user_params
    if @current_user.save
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
