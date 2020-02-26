class Api::UsersController < Api::SecuredApiController
  load_and_authorize_resource

  def dashboard
    #TODO: Implement
  end

  def profile
    render json: @current_user.to_json
  end

  def update
    #TODO: Implement
  end

  def destroy
    #TODO: Implement
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
end
