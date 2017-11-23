class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    p request.env['omniauth.auth']
    #look up existing user with this facebook account
    #or we create a new user with this account

    redirect_to root_path
  end

end
