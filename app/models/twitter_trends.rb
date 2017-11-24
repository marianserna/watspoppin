class TwitterTrends

  attr_accessor :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch("TWITTER_API_KEY")
      config.consumer_secret     = ENV.fetch("TWITTER_SECRET_KEY")
      config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN")
      config.access_token_secret = ENV.fetch("TWITTER_ACCESS_TOKEN_SECRET")
    end
  end

  def trends
    place = @client.trends_closest({lat: latitude, long: longitude}).first
    @client.trends(place.id).to_a.map(&:name).select { |trend|
      trend.starts_with?('#')
    }
  end

end
