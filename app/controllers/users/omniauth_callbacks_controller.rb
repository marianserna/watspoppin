class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :set_service
  before_action :set_user

  attr_reader :service

  #look up existing user with a provider account or we create a new user with this account

  def facebook

    if service.present? #if the service exists

      user = service.user #set the user to the service's user
      service.update(
        expires_at: Time.at(auth.credentials.expires_at),
        access_token: auth.credentials.token
      ) # update the credentials to the newest ones on every log in

    else

      # create the service associated with the user from the oauth hash, we pull the data from the oauth response hash that we printed to the console
      user.services.create(
        provider: auth.provider,
        uid: auth.uid,
        access_token: auth.credentials.access_token,
        expires_at: Time.at(auth.credentials.expires_at), #convert expiration date to a timestamp
        auth: auth #save the hash for future consideration
      )

    end

    sign_in_and_redirect user, event: :authentication
    set_flash_message :notice, :success, kind: "Facebook"
  end

  def twitter
    # 1. the user is singed in and the service already exits, we just update access token
    # 2. user is signed in and they dont have this service, so we connect
    # 3. user is logged out and they dont have an account at all
    # 4. user is logged out and they have an account alredy that matches, look up service and then log them in
    # 5. user is logged out and they log in to a new account that doesnt match their old one, we throw exception to let them know
  end

private

  def auth
    request.env['omniauth.auth'] # can print to console to see the result
  end

  def set_service
    # look up the service in the db with the before action
    @service = Service.where(provider: auth.provider, uid: auth.uid).first
  end

  def set_user

    if user_signed_in?
      @user = current_user

    elsif service.present?
      @user = service.user

    else

      if User.where(email: auth.info.email).any?
        flash[:alert] = "An Account already exists, pelase connect with #{auth.provider.titalize} accout"
        redirect_to new_user_session_path
      end

      # if doesnt exist, create the user
      user = User.create(
        email: auth.info.email,
        name: auth.info.name,
        password: Devise.friendly_token[0,20]
      )
    end

  end
end
