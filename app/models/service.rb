class Service < ApplicationRecord
  belongs_to :user

  def client
    Koala::Facebook::API.new(access_token) #instansiate koala and pass in the access_token from the corresponding column in our model
  end
end
