class Api::UsersController < Api::SecuredApiController
  load_and_authorize_resource

  def dashboard
    #TODO: Implement
  end

  def profile
    render json: @current_user.to_json
  end

  def update
    #TODO: Test!
    if @current_user.update user_params
      @message = "User successfully updated"
      @status = 200
    else
      @message = "Something went wrong"
      @status = 500
    end
    render json: @message.to_json, status: @status
  end

  def destroy
    #TODO: Test!
    unless Settings.user.discard.disabled
      sign_out @user
      if @user.discard
        @message = "User successfully discarded"
        @status = 200
      else
        @message = "Something went wrong"
        @status = 500
      end
      render json: @message.to_json, status: @status
    end
  end

  # Plural Routes
  def index
    #TODO: Implement
  end

  def show
    #TODO: Show Infos about a user the requesting user is allowed to see!
    if can? :show, @user
      render json: @user.to_json
    end
  end

  private

  def user_params
    params.require(:user).permit(:department, :birth_date,
                                 :last_name, :first_name, :email,
                                 :avatar, :avatar_cache, :avatar_type)
  end
end
