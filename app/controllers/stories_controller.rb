class StoriesController < ApplicationController
  before_action :require_login , only: [:new, :create]
  helper_method :linked_to_twitter? , :linked_to_facebook?

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.user_id = current_user.id

    if @story.save

      hashtags = extract_hashtags(@story)
      @story.insert_hashtags(hashtags)

      flash.notice = 'Story created'
      # raise :test
      @story.post_to_twitter if params[:story][:twitter] == "1"
      @story.post_to_facebook if params[:story][:facebook] == "1"

      redirect_to root_path
    else
      flash.alert = 'Story could not be created. Please correct errors and try again.'
      render 'new'
    end

  end

  def search
    load_stories

    if @hashtag_stories.blank?
      begin
        twitter_searcher = TwitterSearcher.new(params[:hashtag], params[:latitude], params[:longitude])
        twitter_searcher.search

        load_stories
      rescue Twitter::Error::TooManyRequests
        puts 'Twitter too many requests'
      end
    end

    render json: (@hashtag_stories.present? ? @hashtag_stories : @stories)
  end

  private

  def story_params
    params.require(:story).permit(:content, :image, :latitude, :longitude)
  end

  def require_login
    if !user_signed_in?
      flash.notice = "Please log-in to create a story"
      redirect_to root_path
    end
  end

  def linked_to_facebook?
    return current_user.services.where(provider: "facebook").any?
  end

  def linked_to_twitter?
    return current_user.services.where(provider: "twitter").any?
  end

  #extract hashtags from story content, remove hash symbol and return them
  def extract_hashtags(story)
    content_words = story.content.split(" ")
    hashtags = content_words.select do |word|
      word.chars.first == "#"
    end
    hashtags.each do |hashtag|
      hashtag = hashtag.slice!(0)
    end
    return hashtags
  end

  def load_stories
    @hashtag = Hashtag.find_by(name: params[:hashtag].downcase.delete('#'))

    @hashtag_stories = if @hashtag
      @hashtag.stories.near([params[:latitude], params[:longitude]]).last(100)
    else
      nil
    end

    @stories = Story.near([params[:latitude], params[:longitude]]).last(100)
  end
end
