class TwitterSearcher
  attr_accessor :hashtag, :latitude, :longitude, :client

  def initialize(hashtag, latitude, longitude)
    @hashtag = hashtag
    @latitude = latitude
    @longitude = longitude

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch("TWITTER_API_KEY")
      config.consumer_secret     = ENV.fetch("TWITTER_SECRET_KEY")
      config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN")
      config.access_token_secret = ENV.fetch("TWITTER_ACCESS_TOKEN_SECRET")
    end
  end

  def search
    start_time = Time.zone.now

    client.search(hashtag, geocode: "#{latitude},#{longitude},10km").each do |tweet|
      Story.save_tweet(tweet)
      # Heroku times out after 30 seconds, so let's stop saving tweets
      break if (Time.zone.now - start_time) >= 25
    end
  end
end
