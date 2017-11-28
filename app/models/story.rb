class Story < ApplicationRecord
  mount_uploader :image, StoryImageUploader
  reverse_geocoded_by :latitude, :longitude

  after_create :insert_hashtags

  has_and_belongs_to_many :hashtags
  belongs_to :user, optional: true

  def self.save_tweet(tweet)
    return if !tweet.respond_to?(:retweeted_status?)
    return if tweet.retweeted_status?
    return if !tweet.geo?
    return if Story.find_by(uid: tweet.id)

    story = Story.new({
      content: tweet.text,
      source: 'Twitter',
      uid: tweet.id,
      handle: tweet.user.screen_name,
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
    story
  end

  def self.remove_old_tweets
    Story.where(source: "Twitter").where("created_at < ?", 24.hours.ago).delete_all
  end

  # Twitter Post Methods
  def post_to_twitter
    if user && user.services.where(provider: "twitter").any?
      user.twitter(self.content)
    end
  end
  
  # Facebook Post Methods
  def post_to_facebook
    if user && user.services.where(provider: "facebook").any?
      user.facebook(self.content)
    end
  end

  #after create - insert hashtags to enable searching
  def insert_hashtags
    #create an array of the words in the tweet
    content_words = self.content.split(" ")
    hashtags = content_words.select do |word|
      word.chars.first == "#"
    end

    #remove the hash symbol form each hashtag
    hashtags.each do |hashtag|
      hashtag = hashtag.slice!(0)
    end

    #check whether each hashtag is in the hashtags table
    #if it is then create record in join table
    #if not then create new record in hastags table and insert record in join table
    hashtags.each do |hashtag|
      hashtag_obj = Hashtag.find_by(name: hashtag)
        if hashtag_obj
          self.hashtags << hashtag_obj
        else
          hashtag_obj = Hashtag.new
          hashtag_obj.name = hashtag
          self.hashtags << hashtag_obj
        end
    end
  end
end
