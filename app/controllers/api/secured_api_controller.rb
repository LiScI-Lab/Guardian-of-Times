class Api::SecuredApiController < ActionController::API
  include TokenGeneratorHelper

  before_action :auth_user

  def auth_user
    begin
      user_id = verify_token request.authorization
      @current_user = User.find(user_id)
    rescue JWT::VerificationError, JWT::DecodeError => e
      head :unauthorized
    end
  end
end
