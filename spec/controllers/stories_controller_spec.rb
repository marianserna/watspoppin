require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  describe 'GET search' do
    it 'finds and returns stories as json' do
      # mocking with method stubs --> don't render search method(twitter_searcher.search)
      expect_any_instance_of(TwitterSearcher).to receive(:search)

      hashtag = create(:hashtag)
      story = create(:story, {hashtags: [hashtag]})

      get :search, params: {hashtag: 'cat', latitude: 43.6532, longitude: -79.3832}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
        [{
          "id"=>story.id,
          "user_id"=>nil,
          "content"=>"Soy un tweet",
          "source"=>"Twitter",
          "image"=>{"url"=>nil, "thumb"=>{"url"=>nil}},
          "latitude"=>43.6532,
          "longitude"=>-79.3832,
          "created_at"=>JSON.parse(story.created_at.to_json),
          "updated_at"=>JSON.parse(story.updated_at.to_json),
          "uid"=>nil,
          "handle"=>nil,
          "distance"=>0.0,
          "bearing"=>"0.0"
        }]
      )
    end
  end

  describe 'GET #new' do
    it "requires login when clicking story button" do
      get :new
      expect(response).to redirect_to root_url
    end

    it 'renders new story view when user logged in' do
      current_user = FactoryBot.attributes_for(:user)
      get :new
      expect(response).to render_template(:new)
    end

  end

  describe "POST #create" do
    it "requires login when posting to stories#create" do
      post :create, :params => { :story => FactoryBot.attributes_for(:story) }
      expect(response).to redirect_to root_url
    end
  end

end
