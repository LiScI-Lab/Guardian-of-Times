class User::SessionsController < Devise::SessionsController

  def new
    render 'welcome/index'
  end
end