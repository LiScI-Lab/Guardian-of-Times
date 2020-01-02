class Api::UserController < Api::SecuredApiController
  def profile
    render json: @current_user.to_json
  end
end
