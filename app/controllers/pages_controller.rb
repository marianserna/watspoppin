class PagesController < ApplicationController

  def main
    # get current lat|lon with Geocoder
    result = request.location

    @props = {
      latitude: result.ip == '127.0.0.1' ? 43.653226 : result.latitude,
      longitude: result.ip == '127.0.0.1' ? -79.383184 : result.longitude
    }
  end

end
