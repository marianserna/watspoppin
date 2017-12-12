class PagesController < ApplicationController

  def main
    # get current lat|lon with Geocoder
    result = request.location
    latitude = ['127.0.0.1', '0.0.0.0'].include?(result.ip) ? 43.653226 : result.latitude
    longitude = ['127.0.0.1', '0.0.0.0'].include?(result.ip) ? -79.383184 : result.longitude

    twitter_trends = TwitterTrends.new(latitude, longitude)

    @props = {
      latitude: latitude,
      longitude: longitude,
      stories: Story.near([latitude, longitude]).reorder(id: :desc).limit(100),
      trending_hashtags: twitter_trends.trends,
      user: current_user,
      liked_story_ids: current_user ? current_user.likes.pluck(:story_id) : []
    }
  end

end
