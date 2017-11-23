class Service < ApplicationRecord
  belongs_to :user

  def client
    send("#{provider}_client") #meta programing that sends calls to the provider_client's method
  end

  def facebook_client
    Koala::Facebook::API.new(access_token) #instansiate koala and pass in the access_token from the corresponding column in our model
  end

  def access_token
    if expires_at? && expires_at <= Time.zone.now #expiration date exists and is less than now
      new_token_info = Koala::Facebook::Omniauth.new.exchange_access_token_info(super)  #talks to database and grab token and talk to koala and exchange the old token with new one from facebook
      udpate(
        access_token: new_token_info["access_token"],
        expires_at: Time.zone.now + new_token_info["expires_in"]
      )
    end

    super #return the new token that we just saved to database or return the old token
  end
end
