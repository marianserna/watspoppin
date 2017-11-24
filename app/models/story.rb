class Story < ApplicationRecord
  mount_uploader :image, StoryImageUploader
  reverse_geocoded_by :latitude, :longitude

  has_and_belongs_to_many :hashtags
  belongs_to :user, optional: true

  def self.save_tweet(tweet)
    return if !tweet.is_a?(Twitter::Tweet)
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


  def self.save_instagram(post)
    return if !post.location
    return if Story.find_by(uid: post.id)
    return if post.type != 'image'

    story = Story.new({
      content: post.caption,
      source: 'Instagram',
      uid: post.id,
      handle: post.user.username,
      longitude: post.location.longitude,
      latitude: post.location.latitude
    })


    story.remote_image_url = post.images.standard_resolution.url

    hashtags = post.tags.map do |insta_tag|
      Hashtag.find_or_create_by!({
        name: insta_tag.downcase
      })
    end

    story.hashtags = hashtags
    story.save!
    story
  end
end
