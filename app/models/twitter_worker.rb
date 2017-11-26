class TwitterWorker
  include Celluloid::IO

  attr_accessor :client

  STREAM_CONNECTION_OPTS = {
     tcp_socket_class: Celluloid::IO::TCPSocket,
     ssl_socket_class: Celluloid::IO::SSLSocket
   }

  def initialize(lat, lng)
    @latitude = lat
    @longitude = lng

    @client = Twitter::Streaming::Client.new(STREAM_CONNECTION_OPTS) do |config|
      config.consumer_key = ENV.fetch("TWITTER_API_KEY")
      config.consumer_secret = ENV.fetch("TWITTER_SECRET_KEY")
      config.access_token = ENV.fetch("TWITTER_ACCESS_TOKEN")
      config.access_token_secret = ENV.fetch("TWITTER_ACCESS_TOKEN_SECRET")
    end
  end

  def run
    # async comes from celluloid. It's running the stream method asynchronously
    async.stream
  end

  private

  def stream
    center_point = [@longitude, @latitude]
    box = Geocoder::Calculations.bounding_box(center_point, 20)
    locations = box.join(',')

    puts "Querying for locations #{locations}"

    client.filter({locations: locations, language: 'en'}) do |tweet|
      puts tweet.inspect
      story = Story.save_tweet(tweet)

      if story
        ActionCable.server.broadcast('stories_channel', story)
      end
    end
  end

end
