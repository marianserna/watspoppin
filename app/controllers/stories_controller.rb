class StoriesController < ApplicationController
  before_action :require_login , only: [:new, :create]

  def new
      @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.user_id = current_user.id
    @story.source = "watspoppin"

    if @story.save

      #create an array of the words in the tweet
      content_words = @story.content.split(" ")
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
            @story.hashtags << hashtag_obj
          else
            hashtag_obj = Hashtag.new
            hashtag_obj.name = hashtag
            @story.hashtags << hashtag_obj
          end
      end

      flash.notice = 'Story created'
      redirect_to root_path
    else
      flash.alert = 'Story could not be created. Please correct and try again.'
      render 'new'
    end

  end

  def search
    begin
      twitter_searcher = TwitterSearcher.new(params[:hashtag], params[:latitude], params[:longitude])
      twitter_searcher.search
    rescue Twitter::Error::TooManyRequests
      puts 'Twitter too many requests'
    end

    @hashtag = Hashtag.find_by(name: params[:hashtag].downcase.delete('#'))

    if @hashtag
      @stories = @hashtag.stories.near([params[:latitude], params[:longitude]]).last(100)
    else
      @stories = Story.near([params[:latitude], params[:longitude]]).last(100)
    end

    render json: @stories
  end

  private

  def story_params
    params.require(:story).permit(:content, :image, :latitude, :longitude, :user_id, :soruce)
  end

  def require_login
    if !user_signed_in?
      flash.notice = "Please log-in to create a story"
      redirect_to root_path
    end
  end


end
# old Code that was refactored
# @story = Story.new
# @story.content = params[:story][:content]
# @story.image = params[:story][:image]
# @story.latitude = params[:story][:latitude]
# @story.longitude = params[:story][:longitude]
# @story.user_id = current_user.id
