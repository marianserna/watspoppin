class PagesController < ApplicationController

  def main
    # get current lat|lon with Geocoder
    result = request.location

    @props = {
      latitude: result.latitude,
      longitude: result.longitude
    }
  end

end
