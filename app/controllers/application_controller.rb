class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale

  protect_from_forgery with: :exception

  acts_as_token_authentication_handler_for User

  before_action :set_locale_from_params
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
      @current_member = @team.members.find_by user: @current_user unless @team.nil?
      @current_ability = Ability.new(current_user, @current_member)
    end
    @current_ability
  end

  private
  def set_locale_from_params
    I18n.locale = params[:locale] || I18n.locale
  end

end
