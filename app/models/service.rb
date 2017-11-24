class Service < ApplicationRecord
  belongs_to :user

# Scopes
  %w{ facebook twitter }.each { |provider|
    scope provider, ->{ where(provider: provider)}
  }

  def client
    send("#{provider}_client") #meta programing that sends calls to the provider_client's method
  end

  def expired?
    expires_at? && expires_at <= Time.zone.now # if expiration date exists and is less than now
  end

  def access_token
      send("#{provider}_refresh_token!") if expired? #send calls to _refresh_token method dynamically
    super #return the new token that we just saved to database or return the old token
  end

# Facebook Methods
  def facebook_client
    Koala::Facebook::API.new(access_token) #instansiate koala and pass in the access_token from the corresponding column in our model
  end

  def facebook_refresh_token!
    new_token_info = Koala::Facebook::Omniauth.new.exchange_access_token_info(access_token)  #talks to database and grab token and talk to koala and exchange the old token with new one from facebook
    udpate(
      access_token: new_token_info["access_token"],
      expires_at: Time.zone.now + new_token_info["expires_in"]
    )
  end

end
