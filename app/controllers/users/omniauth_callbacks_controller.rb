class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :set_service
  before_action :set_user

  attr_reader :service, :user

  # 1. the user is singed in and the service already exits, we just update access token
  # 2. user is signed in and they dont have this service, so we connect
  # 3. user is logged out and they dont have an account at all
  # 4. user is logged out and they have an account alredy that matches, look up service and then log them in

  def facebook
    handle_auth "facebook"
  end

  def twitter
    handle_auth "twitter"
  end

private



  def auth
    request.env['omniauth.auth'] # can print to console to see the result
  end

  def handle_auth(kind)
    # raise :test
    if service.present? #if the service exists
      service.update(service_attributes) # update the credentials to the newest ones on every log in
    else
      # create the service associated with the user from the oauth hash, we pull the data from the oauth response hash that we printed to the console
      user.services.create(service_attributes)
    end

    if user_signed_in?
      flash[:notice] = "Your #{kind} is now Connected"
      redirect_to edit_user_registration_path
    else
      sign_in_and_redirect user, event: :authentication
      set_flash_message :notice, :success, kind: kind
    end
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
    elsif User.where(email: auth.info.email).any?
      # 5. user is logged out and they log in to a new account that doesnt match their old one, we throw exception to let them know
        flash[:alert] = "An Account already exists, pelase connect with #{auth.provider.titalize} accout"
        redirect_to new_user_session_path
    else
      # if doesnt exist, create the user,
      @user = create_user
    end
  end

  def service_attributes
    expires_at = auth.credentials.expires_at.present? ? Time.at(auth.credentials.expires_at) : nil
    {
      provider: auth.provider,
      uid: auth.uid,
      access_token: auth.credentials.token,
      access_token_secret: auth.credentials.secret,
      expires_at: expires_at, #convert expiration date to a timestamp
      auth: auth #save the hash for future consideration
    }
  end

  # def update_attributes
  #   {
  #     expires_at: Time.at(auth.credentials.expires_at),
  #     access_token: auth.credentials.token
  #   }
  # end

  def create_user
    User.create(
      email: auth.info.email,
      name: auth.info.name,
      password: Devise.friendly_token[0,20]
    )
  end

end
