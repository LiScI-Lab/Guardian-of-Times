class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def cas3
    auth = request.env["omniauth.auth"]
    omniauth(auth, "CAS")
  end

  def github
    auth = request.env["omniauth.auth"]
    omniauth(auth, "GitHub")
  end

  def twitter
    auth = request.env["omniauth.auth"]
    omniauth(auth, "Twitter")
  end

  def google_oauth2
    auth = request.env["omniauth.auth"]
    auth.info.image = auth.info.image.gsub /50$/, '150'
    omniauth(auth, "Google")
  end

  private
  def omniauth(auth, provider)
    if auth.info.name.nil?
      auth.info.name = auth.info.nickname
    end

    @user = User.from_omniauth(auth, current_user)
    if @user.persisted?
      sign_in @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => provider) if is_navigational_format?
    else
      session["devise.auth_data"] = auth
    end

    if @user and (@user.sign_in_count <= Settings.user.maximum_sign_ins_redirected_to_edit and @user.birth_date.nil? and @user.department.nil?)
      redirect_to edit_user_path(@user)
    else
      redirect_to request.env['omniauth.origin'] || root_path
    end
  end
end