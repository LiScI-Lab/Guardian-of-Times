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
    sign_out @user
    if @user.discard
      flash[:success] = "User successfully discarded"
      redirect_to '/'
    else
      flash[:error] = "User not discarded"
      redirect_to :back
    end
  end

  private
  def user_params
    params.require(:user).permit(:department, :birth_date,
                                 :avatar, :avatar_cache, :avatar_type)
  end
end
