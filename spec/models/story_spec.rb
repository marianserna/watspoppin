require 'rails_helper'

RSpec.describe Story, type: :model do
  describe '#save_tweet' do
    it 'saves tweet to database' do
      # https://www.ombulabs.com/blog/rspec/ruby/spy-vs-double-vs-instance-double.html
      tweet = instance_double(Twitter::Tweet, {
        retweeted_status?: false,
        geo?: true,
        id: '101',
        text: "Soy un tweet",
        # OpenStruct
        user: OpenStruct.new({
          screen_name: 'tenderlove'
        }),
        geo: OpenStruct.new({
          latitude: 43.6532,
          longitude: -79.3832
        }),
        media: [OpenStruct.new({
          media_uri_https: 'https://www.runnersworld.com/sites/runnersworld.com/files/styles/listicle_slide_custom_user_phone_1x/public/beagle2.jpg?itok=lv5EvG-2'
        })],
        hashtags: [OpenStruct.new({
          text: 'dogdogdog'
        })]
      })

      story = Story.save_tweet(tweet)

      expect(story).to be_a(Story)
      expect(tweet.hashtags.count).to eq(1)
      expect(Story.count).to eq(1)
    end
  end


  describe '#remove_old_tweets' do
    it 'deletes tweets older than 24 hours' do
      story = create(:story)
      story.created_at = 48.hours.ago
      story.save!

      Story.remove_old_tweets
      expect(Story.count).to eq(0)
    end
  end

  describe 'create story' do
    it 'create instance of story model and make sure it saves' do
      story = Story.new
      story.content = "this is a test"
      story.save
      expect(story.persisted?).to eql(true)
    end
  end

  describe 'story associations' do
    it "should have many hashtags" do
      story = Story.reflect_on_association(:hashtags)
      expect(story.macro).to eq(:has_and_belongs_to_many)
    end
  end

  describe 'story validations' do
    it 'Story content longer than 280 characters should throw an error' do
      story = Story.create(content: "This is a very long story so that we can test the validations. It should throw an error since the story cannot be longer than 280 characters. Entering some other random stuff just to increase the number of characters and exceed the 280 limit. We chose 280 limit because this is the character limit of twitter.")
      expect(story.errors[:content]).to eql(['is too long (maximum is 280 characters)'])
    end
    it "Empty story content should throw an error" do
      story = Story.create(content: "")
      expect(story.errors[:content]).to eql(["can't be blank"])
    end
  end

end
