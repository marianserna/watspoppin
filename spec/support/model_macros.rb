module ModelMacros

  # def twitter_config_mock
  #   client = Twitter::REST::Client.new do |config|
  #     config.consumer_key        = "YOUR_CONSUMER_KEY"
  #     config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  #     config.access_token        = "YOUR_ACCESS_TOKEN"
  #     config.access_token_secret = "YOUR_ACCESS_SECRET"
  #   end
  # end

  def twitter_config_mock
    config = {
    consumer_key:         "YOUR_CONSUMER_KEY",
    consumer_secret:      "YOUR_CONSUMER_SECRET",
    access_token:         "YOUR_ACCESS_TOKEN",
    access_token_secret:  "YOUR_ACCESS_SECRET"
    }
  end

end
