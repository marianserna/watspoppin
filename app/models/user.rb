class User < ApplicationRecord
  has_many :stories
  has_many :services
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

   def twitter
     client = Twitter::REST::Client.new(twitter_config)
   end

   def twitter_config
     config = {
     consumer_key:         "TWITTER_CONSUMER_KEY",
     consumer_secret:      "TWITTER_CONSUMER_SECRET",
     access_token:         "TWITTER_API_ACCESS_TOKEN",
     access_token_secret:  "TWITTER_API_ACCESS_TOKEN_SECRET"
     }
   end
   
end
