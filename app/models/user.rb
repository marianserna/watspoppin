class User < ApplicationRecord
  mount_uploader :image, AvatarUploader

  validates_presence_of :name, :password

  has_many :stories
  has_many :services, dependent: :destroy
  has_many :likes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

# Twitter User methods
  def twitter(tweet)
   @client ||= Twitter::REST::Client.new(twitter_config)
   @client.update(tweet)
  end

 def twitter_config
   config = {
   consumer_key:         ENV["TWITTER_CONSUMER_KEY"],
   consumer_secret:      ENV["TWITTER_CONSUMER_SECRET"],
   access_token:         self.services.where(provider: "twitter").first.access_token,
   access_token_secret:  self.services.where(provider: "twitter").first.access_token_secret
   }
 end

# Facebook Access Methods
 def facebook(wall_post)
   @graph ||= self.services.where(provider: "facebook").first.facebook_client # call the facebook_client method in service model that refreshes our access token every time.
   # raise :test
   # @graph.put_connections("me", "feed", message: wall_post) alternate method to the refactored below
   @graph.put_wall_post(wall_post)
 end

 def likes?(story)
   story.likes.where(user_id: id).any?
 end

end
