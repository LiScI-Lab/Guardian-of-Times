class Api::SecuredApiController < ActionController::API
  include CanCan::ControllerAdditions
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

  def current_user
    @current_user unless @current_user.nil?
  end

  def current_ability
    if @current_ability.nil?
      @current_user = current_user
      @current_member = @team.members.find_by user: @current_user unless @team.nil?
      @current_ability = Ability.new(current_user, @current_member)
    end
    @current_ability
  end
end
