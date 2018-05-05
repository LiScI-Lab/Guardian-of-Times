class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale

  protect_from_forgery with: :exception

  before_action :set_locale_from_params

  check_authorization unless: :devise_controller?

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
