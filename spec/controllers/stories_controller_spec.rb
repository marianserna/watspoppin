require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  describe 'GET search' do
    it 'finds and returns stories as json' do
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

  fdescribe 'New Story' do

    context 'when user is not logged in' do
      it "redirects to root path" do
        get :new
        expect(response).to redirect_to root_url
      end
      it 'flashes a notice to log in' do
        get :new
        expect(flash[:notice]).to eq("Please log-in to create a story")
      end
      it "cannot post story" do
        post :create, :params => { :story => FactoryBot.attributes_for(:story) }
        expect(response).to redirect_to root_url
      end
    end

    context 'when user is logged in' do
      before(:each) do
        user = FactoryBot.create(:user)
        sign_in user
      end
      it 'renders new story view' do
        get :new
        expect(response).to render_template(:new)
      end
      it 'if story saved, it redirects to root path' do
        story = FactoryBot.attributes_for(:story)
        post :create, :params => { :story => story }
        expect(response).to redirect_to root_path
      end
      it 'if story saved, it flashes message' do
        story = FactoryBot.attributes_for(:story)
        post :create, :params => { :story => story }
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eql("Story created")
      end
      it "if story doesn't save, it flashes message and renders the new template again" do
        story = {:content => nil, :image => nil, :latitude => nil, :longitude => nil}
        post :create, params: { story: story }
        expect(flash[:alert]).to  eq('Story could not be created. Please correct errors and try again.')
        expect(response).to render_template(:new)
      end
    end

  end

  fdescribe 'Hashtags' do
    before(:each) do
      user = FactoryBot.create(:user)
      sign_in user
      story = {:content => "this is a test story to test hashtags.  #test  #hashtagTest  #anotherTest", :image => nil, :latitude => nil, :longitude => nil}
      post :create, params: { story: story }
    end
    it 'when posting story, should extract hashtags and save in join table' do
      expect(Story.last.hashtags.length).to eql(3)
      expect(Story.last.hashtags[0].name).to eql('test')
      expect(Story.last.hashtags[1].name).to eql('hashtagTest')
      expect(Story.last.hashtags[2].name).to eql('anotherTest')
    end
    it 'should be able to seach story via hashtag' do
      testTag = Hashtag.find_by(name: "test")
      expect(testTag.stories[0].content).to eql("this is a test story to test hashtags.  #test  #hashtagTest  #anotherTest")
    end
  end

end
