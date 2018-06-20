############
##
## Copyright 2018 M. Hoppe & N. Justus
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############

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
