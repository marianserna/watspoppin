class PagesController < ApplicationController

  def main
    # get current lat|lon with Geocoder
    result = request.location
    latitude = result.ip == '127.0.0.1' ? 43.653226 : result.latitude
    longitude = result.ip == '127.0.0.1' ? -79.383184 : result.longitude

    twitter_trends = TwitterTrends.new(latitude, longitude)

    @props = {
      latitude: latitude,
      longitude: longitude,
      stories: Story.near([latitude, longitude]).last(100),
      trending_hashtags: twitter_trends.trends
    }
  end

end
