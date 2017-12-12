class Story::LikesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :set_story

  def create
    @story.likes.where(user_id: current_user.id).first_or_create

    head :no_content
  end

  private
    def set_story
      @story = Story.find(params[:story_id])
    end
end
