class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  #look up existing user with a provider account or we create a new user with this account

  def facebook
    # look up the service in the db
    service = Service.where(provider: auth.provider, uid: auth.uid).first

    if service.present? #if the service exists

      user = service.user #set the user to the service's user
      service.update(
        expires_at: Time.at(auth.credentials.expires_at),
        access_token: auth_credentials.token
      ) # update the credentials to the newest ones on every log in

    else  # if doesnt exist, create the user

      user = User.create(
        email: auth.info.email,
        name: auth.info.name,
        password: Devise.friendly_token[0,20]
      )

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

private

  def auth
    request.env['omniauth.auth'] # can print to console to see the result
  end

end
