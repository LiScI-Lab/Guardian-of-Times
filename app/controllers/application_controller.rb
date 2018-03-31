class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  check_authorization unless: :unchecked_controller?

  private
  def unchecked_controller?
    is_a?(::WelcomeController) or devise_controller?
  end

  def authenticate_admin_user!
    raise SecurityError unless current_user.admin?
  end

  def current_ability
    if @current_ability.nil?
      @current_user = current_user
      @current_member = @project.members.find_by user: @current_user unless @project.nil?
      @current_ability = Ability.new(current_user, @current_member)
    end
    @current_ability
  end

end
