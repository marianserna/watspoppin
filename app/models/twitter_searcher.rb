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
    client.search("##{hashtag}", geocode: "#{latitude},#{longitude},20km").each do |tweet|
      save_tweet(tweet)
    end
  end

  def save_tweet(tweet)
    return if !tweet.is_a?(Twitter::Tweet)
    return if tweet.retweeted_status?
    return if !tweet.geo?

    story = Story.new({
      content: tweet.text,
      source: 'Twitter',
      longitude: tweet.geo.longitude,
      latitude: tweet.geo.latitude
    })

    if tweet.media.any?
      story.remote_image_url = tweet.media.first.media_uri_https.to_s
    end

    hashtags = tweet.hashtags.map do |twitter_hashtag|
      Hashtag.find_or_create_by!({
        name: twitter_hashtag.text.downcase
      })
    end

    # a story has & belongs to many hashtags: Save story hashtags
    story.hashtags = hashtags
    story.save!
  end
end
