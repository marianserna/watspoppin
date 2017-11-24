class InstagramSearcher
  attr_accessor :hashtag, :latitude, :longitude

  def initialize(hashtag, latitude, longitude)
    @hashtag = hashtag
    @latitude = latitude
    @longitude = longitude
  end

  def search
    client = Instagram.client(access_token: ENV.fetch("INSTAGRAM_ACCESS_TOKEN"))
    client.media_search(latitude, longitude).each do |post|
      Story.save_tweet(tweet)
    end
  end
end




# get "/media_search" do
#   client = Instagram.client(:access_token => session[:access_token])
#   html = "<h1>Get a list of media close to a given latitude and longitude</h1>"
#   for media_item in client.media_search("37.7808851","-122.3948632")
#     html << "<img src='#{media_item.images.thumbnail.url}'>"
#   end
#   html
# end
